class RecordsController < ApplicationController
    skip_before_action :verify_authenticity_token
    load_and_authorize_resource class: "Record"
    before_action :authenticate, only:[:create, :get_ocupacity]

    rescue_from CanCan::AccessDenied do |exception|
        flash[:warning] = "Acceso Denegado!"
        redirect_to root_url
      end
    def index
        @record_all = Record.all
        respond_to do |format|
            format.html
            format.csv { send_data @record_all.to_csv, filename: "records-until-#{Date.today}.csv" }
        end
    end 
    def expulse
        if @current_user.rol == "admin"
            sign_out_and_redirect(current_user)  
        else
            @laboratory = Laboratory.find(current_user.lab_id)
            @record_all = Record.where(lab_id: @laboratory.id)
            @records_day = @record_all.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
            @records_day.each do |record|
                if not record.student.status
                    @record_new = record.student.records.new(:tipo => record.student.status, :lab_id =>record.lab_id, :foul => true, :description => "Estudiante no generó registro de salida en laboratorio.")
                    @record_new.save  
                    record.student.status = true
                    record.student.save
                end
            end
            sign_out_and_redirect(current_user)  
        end
    end

    def new
        @record = Record.new
    end
    
    def import
        Record.import(params[:file])
        redirect_to root_path, notice: "Registros actualizados"
    end

    def create 
        student = Student.where(rfid: params[:rfid])[0]      
        if student
            if student.status.nil?
                student.status = true
                student.save
            end
            if student.records.any?
                if student.records.last.tipo == 't' && student.records.last.lab_id.to_i != params[:lab_id].to_i
                    @checkout = student.records.new({:tipo => 'f', :lab_id => student.records.last.lab_id, :foul=>true, :description => "Estudiante no generó registro de salida en laboratorio y generó registro de entrada en otro laboratorio."})
                    @checkout.save
                    student.status = !student.status
                    student.save
                end
            end
            @record = student.records.new({:tipo => student.status, :lab_id =>params[:lab_id]})
            today = Time.now.strftime("%Y-%m-%d")
            reservations= Reservation.where(student_id: student.id, date: today, lab_id: params[:lab_id]).where.not(status: "rechazada").where.not(status: "validada-totem")
            has_reservation = reservations.any?
            respond_to do |format|
            if @record.save
                format.json {render json: {'type': 'student', 'data': {student: @record.student, laboratory: @record.student.laboratories, reservation: has_reservation}}, status: 200}
            else
                format.json {render json: @record.errors, status: :unprocessable_entity}
            end
            end
            student.status = !student.status
            student.save
            reservations.each do |reservation|
                reservation.status = "validada-totem"
                reservation.save
            end
        else    
            respond_to do |format|
                format.json {render json: {'type': 'nonexistent', 'data': {'rfid' => params[:rfid] }}}
            end
        end
    end

    def get_occupation
        result = {}
        laboratories = Laboratory.all.order(id: :asc)
        records = Record.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
        laboratories.each do |lab|
            lab_records = records.where(lab_id: lab.id)
            occupation = lab_records.where(tipo: true).count - lab_records.where(tipo: false).count
            occupation = occupation < 0 ? 0: occupation 
            result[lab.id] = {
                'name' => lab.nombre,
                'capacity' => lab.capacity,
                'occupation' => occupation,
                'occupation_percentage' => occupation*100/lab.capacity
            }
        end
        return render json: result
    end

    def get_records
        start = params[:start].to_date
        end_date= params[:end].blank? ? "": params[:end].to_date 
        if !end_date.blank?
            return render json: Record.where(lab_id: params[:lab_id], created_at: start.beginning_of_day..end_date.end_of_day).order(created_at: :desc)
        end
        return render json: Record.where(lab_id: params[:lab_id], created_at: start.beginning_of_day.. start.end_of_day).order(created_at: :desc)
    end 
end
