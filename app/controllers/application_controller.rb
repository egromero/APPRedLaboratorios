class ApplicationController < ActionController::Base
    include CanCan::ControllerAdditions
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected


    def configure_permitted_parameters
            devise_parameter_sanitizer.permit(:sign_up, keys: [:lab_id, :admin])
            devise_parameter_sanitizer.permit(:account_update, keys: [:lab_id, :admin])
    end
end
