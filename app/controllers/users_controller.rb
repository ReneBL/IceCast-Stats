class UsersController < ApplicationController
  protect_from_forgery with: :exception
  skip_before_filter :check_authentication, :only => [:index, :create]
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
      abort :wrong_login, "Login no válido"
    elsif !user.authenticate(params[:session][:password])
      abort :wrong_password, "Password no válida"
    else
      log_in(user)
      redirect_to home_path
    end
  end
  
  def destroy
    log_out
    redirect_to root_path
  end
  
  private
  # Método genérico de generación de mensaje flash con redirección a página de inicio
  def abort cause, message
    flash[cause] = message
    redirect_to root_path
  end
  
  def session_params
    params.require(:session).permit(:login, :password)
  end
  
end
