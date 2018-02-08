class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  helper_method :current_user
  
  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end
  
  def login_user!
    token = @user.reset_session_token!
    session[:session_token] = token
  end
  
  def logout!
    if current_user
      current_user.reset_session_token!
      session[:session_token] = nil
    end
  end
  
  def ensure_logged_in
    unless current_user
      redirect_to new_session_url
    end
  end
  
  def ensure_logged_out
    if current_user
      redirect_to cats_url
    end
  end
  
end
