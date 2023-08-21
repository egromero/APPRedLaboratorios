class MachinesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @machines = Machine.all
  end

  def new
    @laboratories = current_user.rol == 'admin' ? Laboratory.all : Laboratory.where(id: current_user.lab_id)
  end

  def show
    @machine = Machine.find(params[:id])
    @laboratory = Laboratory.find(@machine.lab_id)
  end

  def enable
    machine = Machine.find(params[:id])
    machine.is_available = true
    machine.save
    render json: { status: 200 }
  end

  def disable
    machine = Machine.find(params[:id])
    machine.is_available = false
    machine.save
    render json: { status: 200 }
  end

  def create
    @machine = Machine.new(machine_params)
    @machine.save
    redirect_to "/machines/lab/#{@machine.lab_id}"
  end

  def laboratories
    is_admin = current_user.nil? ? false : current_user.rol == "admin"
    if is_admin
      @machines = Machine.all
      @laboratories = Laboratory.all
    else
      @machines = Machine.where(lab_id: params[:id])
    end
    @laboratory_id = params[:id]
  end

  private
  def machine_params
    params.require(:machine).permit(:name, :cover_image, :lab_id, :is_available, :description, :weight)
  end
end
