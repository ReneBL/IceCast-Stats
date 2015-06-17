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

module ApplicationHelper
  def log_in(user)
    session[:user_id] = user._id.to_s
  end
  
  def log_out
    session.delete(:user_id)
    session.delete(:source)
    @current_user = nil
    @match = nil
  end
  
  def authenticated?
    current_user != nil
  end
  
  def current_user
    @current_user ||= User.where(_id: session[:user_id]).first
  end
  
  def check_authentication
    redirect_to login_form_path if !authenticated?
  end

  def actived_filter?
    session[:source] != nil
  end

  def filter_name
    session[:source]
  end

  def check_source_filter
    source = session[:source]
    @match = (source != nil) ? {"$match" => {"request" => {"$regex" => ".*#{source}.*"}}} : {"$match" => {}}
  end
end
