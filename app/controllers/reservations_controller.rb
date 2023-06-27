class ReservationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_reservation, only: %i[ show edit update destroy ]

  # GET /reservations or /reservations.json
  def index
    @laboratories = Laboratory.all
  end

  # GET /reservations/1 or /reservations/1.json
  def show
  end

  def get_student_reservation
    student = Student.find_by(rut: params[:rut])
    if student.nil?
      render json: { message: "Student not found", status: 404}
      return;
    end
    wallet = student.current_wallet
    reservations = Reservation.where(student_id: student.id)
    reservations_object = []
    reservations.each do |reservation|
      machine = Machine.find(reservation.machine_id).name
      laboratory = Laboratory.find(reservation.lab_id).nombre
      reservations_object << { date: reservation.date, hour_block: reservation.hour_block, machine: machine, laboratory: laboratory }
    end

    render json: { student: { name: student.nombre, rut: student.rut },
                   wallet: { hours: wallet.hours }, 
                   reservations: reservations_object,
                   status: 200 }
  end

  # GET /reservations/new
  def new
    @machine = Machine.find(params[:machine_id])
    @laboratory = Laboratory.find(@machine.lab_id)
    @reservations = Reservation.where(machine_id: params[:machine_id])
    @reservation = Reservation.new
  end

  # GET /reservations/1/edit
  def edit
  end

  def occupied
    date = params[:date]
    machine_id = params[:machine_id]
    reserved = Reservation.where(date: date, machine_id: machine_id).pluck(:hour_block)
    render json: { hours: reserved }
  end

  # POST /reservations or /reservations.json
  def create
    # @reservation = Reservation.new(reservation_params)
    blocks = params[:blocks].first.gsub!(/[\[\]\"]/, '').split(',')
    asked_hours = blocks.length * 0.5
    @reservations = []
    check_machines = Reservation.where(machine_id: params[:machine_id], date: params[:date], hour_block: blocks)
    unless check_machines.empty?
      respond_to do |format|
        format.html { redirect_to reservations_path, notice: "Una o más horas ya están tomadas." }
      end
      return;
    end
    student = Student.find_by(rut: params[:student_rut])
    if student.nil?
      respond_to do |format|
        format.html { redirect_to reservations_path, notice: "El estudiante no existe." }
      end
      return;
    end
    student_id = student.id
    if asked_hours > student.current_wallet.hours
      respond_to do |format|
        format.html { redirect_to reservations_path, notice: "No tienes suficientes horas para reservar." }
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
        format.html { redirect_to reservations_path, notice: "Algunas reservas no fueron creadas." }
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
end
