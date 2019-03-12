class VisitsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        @laboratory = Laboratory.find(current_user.lab_id)
        @visits_day = Visit.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
        @visits_day = @visits_day.where(lab_id: @laboratory.id)
        @visits_week = Visit.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)
        @visits_week = @visits_week.where(lab_id: @laboratory.id)
        @visits_month = Visit.where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)
        @visits_month = @visits_month.where(lab_id: @laboratory.id)
    end

    def new
        @visit = Visit.new
    end

    def import
        Visit.import(params[:file])
        redirect_to root_path, notice: "Registros de visitas actualizados"
    end
    
    def create 
        st_id = Student.where(rut: params[:rut])[0]
        if st_id 
            @record = st_id.records.new({:tipo => params[:tipo], :lab_id => params[:lab_id]})
            respond_to do |format|
            if @record.save
                format.json {render json: {'type': 'student', 'data': @record.student}, status: 200}
            else
                format.json {render json: @record.errors, status: :unprocessable_entity}
            end
            end
        else    
            
            @visit = Visit.new(rut: params[:rut], motivo: params[:motivo], institucion: params[:institucion])
            respond_to do |format|  
            if @visit.save
                format.json {render json: {'type': 'visit', 'data': @visit}, status: 200}
            else
                format.json {render json: @visit.errors, status: :unprocessable_entity}
            end
            end
        end
    end 


end


