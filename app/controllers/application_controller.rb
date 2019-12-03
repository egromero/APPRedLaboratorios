class ApplicationController < ActionController::Base
    include CanCan::ControllerAdditions
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected


    def configure_permitted_parameters
            devise_parameter_sanitizer.permit(:sign_up, keys: [:lab_id, :admin])
            devise_parameter_sanitizer.permit(:account_update, keys: [:lab_id, :admin])
    end

    def authenticate
        api_key = request.headers['X-Api-Key']
        print 'Recibí api key'
        print api_key
        @totem = Totem.find_by(api_key: api_key) if api_key
        
        unless @totem
            render json: {error: 'Request no autorizada'}, status: 401
            return false
        end
    end

end

