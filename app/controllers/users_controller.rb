=begin
IceCast-Stats is system for statistics generation and analysis
for an IceCast streaming server
Copyright (C) 2015  René Balay Lorenzo <rene.bl89@gmail.com>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
=end

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
