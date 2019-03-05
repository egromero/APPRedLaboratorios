class VisitsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        @visits = Visit.all
    end

    def new
        @visit = Visit.new
    end

    
    def create 
        st_id = Student.where(rut: params[:rut])[0]
        if st_id 
            @record = st_id.records.new({:tipo => 'ingreso'})
            respond_to do |format|
            if @record.save
                format.json {render json: @record.student, status: 200}
            else
                format.json {render json: @record.errors, status: :unprocessable_entity}
            end
            end
        else    
            
            @visit = Visit.new(rut: params[:rut], motivo: params[:motivo], institucion: params[:institucion])
            respond_to do |format|  
            if @visit.save
                format.json {render json: @visit, status: 200}
            else
                format.json {render json: @visit.errors, status: :unprocessable_entity}
            end
            end
        end
    end 

    private

    def record_params
        params.require(:record).permit(:tipo, :student_id)
    end
end

