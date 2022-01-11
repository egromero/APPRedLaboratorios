class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  load_and_authorize_resource class: "User"
  

  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = "Acceso Denegado!"
    redirect_to root_url
  end
  def index
    @users = User.all
    @labs = Laboratory.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_path, :flash => { :success => 'Usuario creado con exito' }
    else
      render :action => 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      sign_in(@user, :bypass => true) if @user == current_user
      redirect_to @user, :flash => { :success => 'User was successfully updated.' }
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, :flash => { :success => 'User was successfully deleted.' }
  end

  def reset_password
    if current_user.rol=="admin"
      user = User.find(params[:id])
      ucUser = user.email.split("@")[0]
      user.password = ucUser + Time.new.year.to_s
      if user.save
        redirect_to users_path, :flash => { :success => 'Contraseña restablecida' }  
      end
    else
      redirect_to users_path, :flash => { :error => 'Solo el administrador puede hacer esta función' }
    end

  end

  private
    def user_params
      params.permit(:email, :password, :password_confirmation, :rol, :lab_id)
    end


end
