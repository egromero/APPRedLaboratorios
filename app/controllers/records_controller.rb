class RecordsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        @laboratory = Laboratory.find(current_user.lab_id)
        @records_day = Record.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
        @records_day = @records_day.where(lab_id: @laboratory.id)
        @records_week = Record.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)
        @records_week = @records_week.where(lab_id: @laboratory.id)
        @records_month = Record.where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)
        @records_month = @records_month.where(lab_id: @laboratory.id)
        
    end


    def new
        @record = Record.new
    end
    
    def import
        Record.import(params[:file])
        redirect_to root_path, notice: "Registros actualizados"
    end
    #POST /records/rfid,tipo
    def create 
        st_id = Student.where(rfid: params[:rfid])[0]
        if st_id 
            @record = st_id.records.new({:tipo => params[:tipo]})
            respond_to do |format|
            if @record.save
                format.json {render json: @record.student, status: 200}
            else
                format.json {render json: @record.errors, status: :unprocessable_entity}
            end
            end
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
