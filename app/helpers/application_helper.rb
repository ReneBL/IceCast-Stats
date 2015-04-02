module ApplicationHelper
  def log_in(user)
    session[:user_id] = user._id.to_s
  end
  
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
  def authenticated?
    current_user != nil
  end
  
  def current_user
    @current_user ||= User.where(_id: session[:user_id]).first
  end
  
  def check_authentication
    redirect_to root_path if !authenticated?
  end
end
