class LaboratoriesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_laboratory, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource class: "Laboratory"


  # GET /laboratories
  # GET /laboratories.json
  def index
    if current_user.rol == "admin"
        print "administrador"
        @laboratories = Laboratory.all
    else
        print "no administrador!"
        @laboratory = Laboratory.find(current_user.lab_id)
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = "Acceso Denegado!"
    redirect_to root_url
  end

  def show        
    @record_all = Record.where(lab_id: @laboratory.id)
    @records_day = @record_all.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).order(created_at: :desc)
    @records_week = @record_all.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)
    @records_month = @record_all.where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)
    respond_to do |format|
        format.html
        format.csv { send_data @record_all.to_csv, filename: "registros-#{laboratory.nombre}-al-#{Date.today}.csv" }
    end
  end

  # GET /laboratories/new
  def new
    @laboratory = Laboratory.new
  end

  # GET /laboratories/1/edit
  def edit
  end

  def previous_records
    @lab = Laboratory.find(params[:id])
  end

  def new_admin
    @laboratory = Laboratory.find(params[:laboratory_id])
    @users = User.all
  end
  
  def set_admin
    @user = User.find(params[:user_id])
    @laboratory.user_id = @user.id
    respond_to do |format|
    format.html { redirect_to home_page_path, notice: 'Nuevo administrador asignado' }
    end
  end


  # POST /laboratories
  # POST /laboratories.json
  def create
    @laboratory = Laboratory.new(laboratory_params)

    respond_to do |format|
      if @laboratory.save
        format.html { redirect_to @laboratory, notice: 'Laboratory was successfully created.' }
        format.json { render :show, status: :created, location: @laboratory }
      else
        format.html { render :new }
        format.json { render json: @laboratory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /laboratories/1
  # PATCH/PUT /laboratories/1.json
  def update
    respond_to do |format|
      if @laboratory.update(laboratory_params)
        format.html { redirect_to @laboratory, notice: 'Laboratory was successfully updated.' }
        format.json { render :show, status: :ok, location: @laboratory }
      else
        format.html { render :edit }
        format.json { render json: @laboratory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /laboratories/1
  # DELETE /laboratories/1.json
  def destroy
    @laboratory.destroy
    respond_to do |format|
      format.html { redirect_to laboratories_url, notice: 'Laboratory was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_laboratory
      @laboratory = Laboratory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def laboratory_params
      params.require(:laboratory).permit(:nombre, :facultad, :campus)
    end
end
