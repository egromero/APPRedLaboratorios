class StudentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  load_and_authorize_resource class: "Student"
  before_action :authenticate, only:[:created_from_totem]
 

  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = "Acceso Denegado!"
    redirect_to root_url
    end
  # GET /students
  # GET /students.json
  def index
    if current_user.rol == "admin" 
      @students = Student.all.order("id ASC")
    else
      @students = Student.joins(:laboratories).where(laboratories: {id: current_user.lab_id})

    end
  end

  def inconsistency(previus_record, record)
    print "mudando a registro de record"
  end
  helper_method :inconsistency
  
  # GET /students/1
  # GET /students/1.json
  def show
    @labs = Laboratory.all
    if @student.records
      @lasets_records = @student.records.last(4)
    end
    @fouls = @student.records.where(foul: true)
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
    format.html { redirect_to laboratory_path(@labs) , notice: 'Estudiante matriculado' }
    end
  end
  
  # POST /students
  # POST /students.json
  def create
    if Student.where(rfid: student_params[:rfid]).exists?
      respond_to do |format|
        format.html {redirect_to @student, notice: 'MIFARE Estudiante ya existe.'}
      end
      return 0
    end
    @student = Student.new(student_params)
    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: 'Estudiante exitosamente agregado' }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end
  
def created_from_totem
  if Student.where(rfid: params[:rfid]).exists?
    respond_to do |format|
      format.json {render json: @student, status: :created}
    end
    return 0
  end
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

  def get_student
    render json: Student.find(params[:student_id])
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
