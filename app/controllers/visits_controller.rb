require 'net/http'
require 'uri'
require 'json'

# class VisitsController < ApplicationController
#     skip_before_action :verify_authenticity_token
#     load_and_authorize_resource class: "Visit"
  
#     rescue_from CanCan::AccessDenied do |exception|
#       flash[:warning] = "Acceso Denegado!"
#       redirect_to root_url
#     end
  
#     def index
#       @visits_day = Visit.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
#       @visits_week = Visit.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)
#       @visits_month = Visit.where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)
#       @visit_all = Visit.all
#       @labs = Laboratory.all
#       respond_to do |format|
#         format.html
#         format.csv { send_data @visit_all.to_csv, filename: "visit-until-#{Date.today}.csv" }
#       end
#     end
  
#     def show
#       @labs = Laboratory.all
#     end
  
#     def new
#       @labs = Laboratory.all
#       render layout: 'slideshow'
#       @visit = Visit.new
#     end
  
#     def import
#       Visit.import(params[:file])
#       redirect_to root_path, notice: "Registros de visitas actualizados"
#     end
  
#     def create
#       Rails.logger.info "Entrando a create..."
#       @visit_params = params.permit(:rut, :motivo, :institucion, :lab_id, :other, :quantity, :uc_student)
#       Rails.logger.info "Entrando a create..."
#       Rails.logger.info @visit_params
#       # Lógica para enviar una solicitud POST a otro servicio usando net/http
#       Rails.logger.info "Entrando a enviar POST..."
#       uri = URI.parse("https://example.com/api/endpoint") # Cambia esta URL por la del servicio al que necesitas enviar la solicitud
#       http = Net::HTTP.new(uri.host, uri.port)
#       http.use_ssl = (uri.scheme == "https")
#       request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})
#       request.body = @visit_params.to_json
  
#       response = http.request(request)
#       Rails.logger.info "Respuesta recibida..."
#       Rails.logger.info response
  
#       if response.code.to_i == 200
#         flash[:notice] = 'Visita registrada. Bienvenido al Laboratorio'
#         redirect_to slideshow_path, notice: 'Visita registrada exitosamente y solicitud enviada al servicio externo.'
#       else
#         flash[:error] = "Hubo un error al enviar la solicitud al servicio externo."
#         redirect_to slideshow_path
#       end
#     end
#   end

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
        Rails.logger.info "Visit Params"
        Rails.logger.info visit_params

        # Datos a enviar
        data = {
          'fields': {
            'fldl99UjPoKChJyU1': visit_params[:rut],
            'fld4K10yQ9y74ryAO': visit_params[:institucion],
            'fldvLABQiqKIJPgK9': visit_params[:lab_id],
            'fldxNQvUYdFOf9x36': visit_params[:motivo],
            'fldBagNcAy9oSYo1n': visit_params[:other],
            'fldwFwYqPHLi5cqvE': visit_params[:quantity],
            'fldQDfXUY09GkKy1y': visit_params[:uc_student]
          }
        }
    
        # Configuración de la solicitud
        uri = URI.parse("https://api.airtable.com/v0/appAva5Ns7QQbSSVn/tblQKTOunnX5STdms")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json', 'Authorization' => 'Bearer patBExGhe6sVJtn6x.7ee85c8cd5d6afe6bdf4057a06a47dcf377af159ebc728268cd18ea365efb9ff'})
        request.body = data.to_json
    
        # Enviar la solicitud
        Rails.logger.info 'Enviando solicitud...'
        response = http.request(request)
        Rails.logger.info 'Response recibida:'
        Rails.logger.info response

        if response.code.to_i == 200
            Rails.logger.info 'Código 200'
            render json: {type: "visit"}
            redirect_to slideshow_path
          else
            Rails.logger.error "Error al registrar la visita: #{response.message}"
            Rails.logger.error "Cuerpo de la respuesta: #{response.body}"
            #flash[:alert] = "Error al registrar la visita: #{response.message}"
            redirect_to slideshow_path
          end
        #@visit = Visit.new(visit_params)

        # if @visit.save
        #     render layout: 'slideshow', notice: 'Visita registrada exitosamente.'
        # else
        #   render layout: 'slideshow' 
        # end

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

