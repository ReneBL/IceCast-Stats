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
