class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token
  load_and_authorize_resource class: "Student"

  # GET /students
  # GET /students.json
  def index
    @students = Student.all.order("id ASC")
  end
  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = "Acceso Denegado!"
    redirect_to root_url
  end
  # GET /students/1
  # GET /students/1.json
  def show
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end
  def import
    Student.import(params[:file])
    redirect_to root_path, notice: "Estudiantes actualizados"
  end
  def enroll
    @student = Student.find(params[:student_id])
    @labs = Laboratory.find(current_user.lab_id)
    @student.each do |student|
       student.laboratories << @labs
    end
    respond_to do |format|
    format.html { redirect_to records_url , notice: 'Estudiante matriculado' }
    end
  end
  
  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: 'Student was successfully created.' }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

def created_from_totem
  @student = Student.new({:rfid => params[:rfid],:nombre => params[:nombre],
                          :correo => params[:correo], :sit_academica=> params[:sit_academica],
                          :rut => params[:rut]})
  respond_to do |format|
    if @student.save
      format.json {render json: @student, status: :created}
    else
      format.json {render json: @student.errors, status: :unprocessable_entity }
    end
  end
end
  
  
  
  
  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:rfid, :nombre, :rut, :nalumno, :sit_academica, :correo)
    end
end
