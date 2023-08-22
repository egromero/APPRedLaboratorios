class ReservationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_reservation, only: %i[ show edit update destroy ]

  # GET /reservations or /reservations.json
  def index
    @laboratories = Laboratory.all
  end

  def admin_reservations
    if current_user.nil?
      redirect_to reservations_path
      return;
    end
    @lab = Laboratory.find(current_user.lab_id).nombre
    @laboratories = Laboratory.all
  end

  def validate_reservation
    reservation = Reservation.find(params[:id])
    reservation.status = "validada"
    if reservation.save
      render json: { status: 200 }
    else 
      render json: { status: 400 }
    end
  end

  def release_reservation
    reservation = Reservation.find(params[:id])
    reservation.status = "rechazada"
    if reservation.save
      render json: { status: 200 }
    else 
      render json: { status: 400 }
    end
  end

  def get_admin_reservation
    if current_user.nil?
      render json: { status: 400 }
    end
    lab_id = current_user.rol = "admin" ? params[:lab_id] : current_user.lab_id
    date = params[:date]
    reservations = Reservation.where(lab_id: lab_id, date: date).where.not(status: "rechazada")
    reservations_object = []
    reservations.each do |reservation|
      student = Student.find(reservation.student_id)
      machine = Machine.find(reservation.machine_id).name
      reservations_object << { reservation_id: reservation.id, student: student, date: reservation.date, hour_block: reservation.hour_block, machine: machine, status: reservation.status }
    end
    reservations_object_sorted = reservations_object.sort_by { |obj| obj[:hour_block] }
    render json: { reservations: reservations_object_sorted, status: 200 }
  end

  # GET /reservations/1 or /reservations/1.json
  def show
  end


  def get_date_reservation_student
    rut = convert_last_char_to_uppercase(params[:rut])
    student = Student.find_by(rut: rut)
    if student.nil?
      render json: { message: "Student not found", status: 404}
      return;
    end
    date = params[:date]
    reservations = Reservation.where(student_id: student.id, date: date).where.not(status: "rechazada")
    reservations_object = []
    reservations.each do |reservation|
      machine = Machine.find(reservation.machine_id).name
      laboratory = Laboratory.find(reservation.lab_id).nombre
      reservations_object << { id: reservation.id, status: reservation.status, date: reservation.date, hour_block: reservation.hour_block, machine: machine, laboratory: laboratory }
    end
    render json: { reservations: reservations_object, status: 200 }
  end

  def get_student_reservation
    rut = convert_last_char_to_uppercase(params[:rut])
    student = Student.find_by(rut: rut)
    if student.nil?
      render json: { message: "Student not found", status: 404}
      return;
    end
    wallet = student.current_wallet
    occupied  = Reservation.where(student_id: student.id).where.not(status: "rechazada").count * 0.5
    render json: { student: { name: student.nombre, rut: student.rut },
                   wallet: { hours: wallet.hours, occupied: occupied },
                   status: 200 }
  end

  # GET /reservations/new
  def new
    @machine = Machine.find(params[:machine_id])
    @laboratory = Laboratory.find(@machine.lab_id)
    @reservations = Reservation.where(machine_id: params[:machine_id]).where.not(status: "rechazada")
    @reservation = Reservation.new
  end

  # GET /reservations/1/edit
  def edit
  end

  def occupied
    date = params[:date]
    machine_id = params[:machine_id]
    reserved = Reservation.where(date: date, machine_id: machine_id).where.not(status: "rechazada").pluck(:hour_block)
    render json: { hours: reserved }
  end

  # POST /reservations or /reservations.json
  def create
    # @reservation = Reservation.new(reservation_params)
    unless is_almost_today?(params[:date])
      respond_to do |format|
        format.html { redirect_to reservations_path, alert: "La fecha no es correcta." }
      end
      return;
    end
    date = params[:date]
    blocks = params[:blocks].first.gsub!(/[\[\]\"]/, '').split(',')
    asked_hours = blocks.length * 0.5
    @reservations = []
    check_machines = Reservation.where(machine_id: params[:machine_id], date: params[:date], hour_block: blocks).where.not(status: "rechazada")
    unless check_machines.empty?
      respond_to do |format|
        format.html { redirect_to reservations_path, alert: "Una o más horas ya están tomadas." }
      end
      return;
    end
    rut = convert_last_char_to_uppercase(params[:student_rut])
    student = Student.find_by(rut: rut)
    if student.nil?
      respond_to do |format|
        format.html { redirect_to reservations_path, alert: "El estudiante no existe." }
      end
      return;
    end
    student_id = student.id
    if asked_hours > student.current_wallet.hours
      respond_to do |format|
        format.html { redirect_to reservations_path, alert: "No tienes suficientes horas para reservar." }
      end
      return;
    end
    blocks.each do |block|
      @reservation = Reservation.new(
                      date: params[:date],
                      hour_block: block.to_i,
                      student_id: student_id,
                      machine_id: params[:machine_id].to_i,
                      lab_id: params[:lab_id].to_i)
      @reservations.push(@reservation)
    end
    failed_reservations = []
    @reservations.each do |reservation|
      unless reservation.save
        failed_reservations.push(reservation)
      end
    end
    respond_to do |format|
      if failed_reservations.empty?
        student.discount(asked_hours)
        format.html { redirect_to reservations_path, notice: "Reservas creadas correctamente." }
      else
        student.discount(asked_hours - failed_reservations.length * 0.5)
        format.html { redirect_to reservations_path, alert: "Algunas reservas no fueron creadas." }
      end
    end
  end

  # PATCH/PUT /reservations/1 or /reservations/1.json
  def update
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to reservation_url(@reservation), notice: "Reservation was successfully updated." }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1 or /reservations/1.json
  def destroy
    @reservation.destroy

    respond_to do |format|
      format.html { redirect_to reservations_url, notice: "Reservation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reservation_params
      params.fetch(:reservation, {})
    end

    def convert_last_char_to_uppercase(str)
      last_char = str[-1]
      if last_char == 'k'
        str[-1] = last_char.upcase
      end
      str
    end

    def is_almost_today?(date_string)
      date = Date.parse(date_string)
      today = Date.today
      difference = (date - today).to_i
    
      difference >= 0
    end

end
