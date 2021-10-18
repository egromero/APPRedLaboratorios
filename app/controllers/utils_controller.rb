class UtilsController < ApplicationController
    skip_before_action :verify_authenticity_token
    def update_password
        user = User.find(params[:id])
        user.password = params[:new_password]
        if user.save
            redirect_to root_path, :flash => { :success => 'Constraseña actualizada' }
        end
    end
end