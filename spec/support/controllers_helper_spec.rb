module ControllersHelperSpec 
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
    redirect_to login_form_path if !authenticated?
  end
end

RSpec.configure do |config|
  config.include ControllersHelperSpec, :type => :controller
end
