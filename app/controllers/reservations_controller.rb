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
    binding.pry
    blocks.each do |block|
      @reservation = Reservation.new(
                      date:params[:date],
                      hour_block: block.to_i,
                      student_id: student_id,
                      machine_id: params[:machine_id].to_i,
                      lab_id: params[:lab_id].to_i)
    end

    # respond_to do |format|
    #   if @reservation.save
    #     format.html { redirect_to reservation_url(@reservation), notice: "Reservation was successfully created." }
    #     format.json { render :show, status: :created, location: @reservation }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     format.json { render json: @reservation.errors, status: :unprocessable_entity }
    #   end
    # end
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
