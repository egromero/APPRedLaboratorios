class RecordsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        
        @students_ranking = Student
        .left_joins(:records)
        .group(:id)
        .order('COUNT(records.id) DESC')
        .limit(35)
        @laboratory = Laboratory.find(current_user.lab_id)
        @record_all = Record.where(lab_id: @laboratory.id)
        @records_day = @record_all.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
        @records_week = @record_all.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)
        @records_month = @record_all.where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)
        respond_to do |format|
            format.html
            format.csv { send_data @record_all.to_csv, filename: "users-#{Date.today}.csv" }
          end
    end




    
    def expulse
        @laboratory = Laboratory.find(current_user.lab_id)
        @record_all = Record.where(lab_id: @laboratory.id)
        @records_day = @record_all.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
        @records_day.each do |record|
            if not record.student.status
                @record_new = record.student.records.new(:tipo => record.student.status, :lab_id =>record.lab_id)
                @record_new.save  
                record.student.status = true
                record.student.save
            end
        end
        sign_out_and_redirect(current_user)

       
    end


    def new
        @record = Record.new
    end
    
    def import
        Record.import(params[:file])
        redirect_to root_path, notice: "Registros actualizados"
    end
    #POST /records/rfid
    def create 
        student = Student.where(rfid: params[:rfid])[0]
        if student
            if student.status.nil?
                student.status = true
                student.save
            end
            @record = student.records.new({:tipo => student.status, :lab_id =>params[:lab_id]})
            respond_to do |format|
            if @record.save
                format.json {render json: {'type': 'student', 'data': {student: @record.student, laboratory: @record.student.laboratories}}, status: 200}
            else
                format.json {render json: @record.errors, status: :unprocessable_entity}
            end
            end
            student.status = !student.status
            student.save
        else    
            
            respond_to do |format|
                format.json {render json: @record, status:404}

            end
        end
    end 

    private

    def record_params
        params.require(:record).permit(:tipo, :student_id, :lab_id)
    end
end
