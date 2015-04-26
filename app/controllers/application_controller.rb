class ApplicationController < ActionController::Base
  include ApplicationHelper 
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session,
   if: Proc.new { |c| c.request.format == 'application/json' }
  before_filter :check_authentication, :check_source_filter
end
