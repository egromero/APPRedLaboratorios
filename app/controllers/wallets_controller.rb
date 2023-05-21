class WalletsController < ApplicationController
	skip_before_action :verify_authenticity_token
	def edit
    	@student = Student.find(params[:id])
	end

	def modify_wallet
		@student = Student.find(params[:student_id])
		wallet = @student.current_wallet
		wallet.hours = params[:hours].gsub(',', '.').to_f
		wallet.save
		redirect_to students_path , notice: 'Horas actualizadas correctamente'
	end 
end
