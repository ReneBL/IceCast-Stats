class UsersController < ApplicationController
  protect_from_forgery with: :exception
  skip_before_filter :check_authentication, :only => [:index, :create, :login_form]
  before_action :session_params, only: [:create]
   
  def index
    unless authenticated?
      render :layout => false
    else
      redirect_to home_path
    end
  end
  
  def create
    user = User.where(login: params[:session][:login].downcase).first
    # Si el usuario es nil, no queremos probar a autenticarlo, puesto que sería un intento de acceso a una clase nula
    if !user
      abort :wrong_login, "El usuario introducido no ha sido dado de alta en el sistema"
    elsif !user.authenticate(params[:session][:password])
      abort :wrong_password, "La contraseña no es válida"
    else
      log_in(user)
      redirect_to home_path
    end
  end
  
  def destroy
    log_out
    redirect_to root_path
  end
  
  def login_form
    render :layout => false
  end
  
  private
  # Método genérico de generación de mensaje flash con redirección a página de inicio
  def abort cause, message
    flash[cause] = message
    redirect_to login_form_path
  end
  
  def session_params
    params.require(:session).permit(:login, :password)
  end
  
end
