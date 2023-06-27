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

  def create
    @machine = Machine.new(machine_params)
    @machine.save
    redirect_to machines_path
  end

  def laboratories
    @machines = Machine.where(lab_id: params[:id])
    @laboratory_id = params[:id]
  end

  private
  def machine_params
    params.require(:machine).permit(:name, :cover_image, :lab_id, :is_available, :description, :weight)
  end
end
