class RecordsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        @records = Record.all
    end

    def new
        @record = Record.new
    end

    def create
        @record = Record.new({:id_usuario => params[:id_usuario], :tipo => params[:tipo]})
        #respond_to do |format|
        if @record.save
            redirect_to records_path
        end
         #   format.html { redirect_to records_path, notice: 'Registro' }
          #else
           # format.json { render json: @record.errors, status: :unprocessable_entity }
          #end
        #end
    end
end
