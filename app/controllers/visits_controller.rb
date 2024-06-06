class VisitsController < ApplicationController
    skip_before_action :verify_authenticity_token
    load_and_authorize_resource class: "Visit"

    rescue_from CanCan::AccessDenied do |exception|
        flash[:warning] = "Acceso Denegado!"
        redirect_to root_url
      end
    def index
        @visits_day = Visit.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
        @visits_week = Visit.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)
        @visits_month = Visit.where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)
        @visit_all = Visit.all
        @labs = Laboratory.all
        respond_to do |format|
            format.html
            format.csv { send_data @visit_all.to_csv, filename: "visit-until-#{Date.today}.csv" }
        end
    end
    def show
        @labs = Laboratory.all
    end

    
    def new
        Rails.logger.info "Entrando a new..."
        @labs =  Laboratory.all
        render layout: 'slideshow'
        @visit = Visit.new
    end

    def import
        Visit.import(params[:file])
        redirect_to root_path, notice: "Registros de visitas actualizados"
    end
    
    def create
        Rails.logger.info "Entrando a create..."
        render layout: 'slideshow' 
        # student = Student.where(rut: visit_params[:rut])[0]
        # if student 
        #     if student.status.nil?
        #         student.status = true
        #         student.save
        #     end
        #     @record = student.records.new({:tipo => student.status, :lab_id =>visit_params[:lab_id]})
        #     if @record.save
        #         student.status = !student.status
        #         student.save
        #         render json: {type: "student", name: student.nombre}
        #     end
        # else    
        #     @visit = Visit.new(rut: visit_params[:rut], motivo: visit_params[:motivo], institucion: visit_params[:institucion], lab_id: visit_params[:lab_id], other: visit_params[:other], quantity: visit_params[:quantity])
        #     if @visit.save
        #         render json: {type: "visit"}
        #     end
        # end
    end 

    def visit_params
        params.require(:visit).permit(:rut, :motivo, :institucion, :lab_id, :other, :quantity, :uc_student)
    end


end


