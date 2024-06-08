require 'net/http'
require 'uri'
require 'json'

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
        
        #Configuración de la solicitud
        uri = URI.parse("https://api.airtable.com/v0/appAva5Ns7QQbSSVn/tblQKTOunnX5STdms")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json', 'Authorization' => 'Bearer patBExGhe6sVJtn6x.7ee85c8cd5d6afe6bdf4057a06a47dcf377af159ebc728268cd18ea365efb9ff'})
        request.body = data.to_json
    
        #Enviar la solicitud
        Rails.logger.info 'Enviando solicitud...'
        response = http.request(request)
        Rails.logger.info 'Response recibida:'
        Rails.logger.info response

        if response.code.to_i == 200
            Rails.logger.info 'Código 200'
            redirect_to success_visits_path
          else
            Rails.logger.error "Error al registrar la visita: #{response.message}"
            Rails.logger.error "Cuerpo de la respuesta: #{response.body}"
            #flash[:alert] = "Error al registrar la visita: #{response.message}"
            redirect_to slideshow_path
          end
    end
    
    def success
        # Esta acción solo renderiza la vista success.html.erb
    end      

    def visit_params
        params.require(:visit).permit(:rut, :motivo, :institucion, :lab_id, :other, :quantity, :uc_student)
    end

end

