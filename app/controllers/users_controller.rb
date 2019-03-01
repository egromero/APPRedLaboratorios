class UsersController < ApplicationController
    def index
        @users = User.all
    end

    def new
        @User = User.new
    end
    
    def create
        @user = User.new(params[:user]) 
            respond_to do |format|
                if @user.save
                  format.html { redirect_to @user, notice: 'user was successfully created.' }
                  format.json { render :show, status: :created, location: @user }
                else
                  format.html { render :new }
                  format.json { render json: @user.errors, status: :unprocessable_entity }
                end
              end
    end

end
