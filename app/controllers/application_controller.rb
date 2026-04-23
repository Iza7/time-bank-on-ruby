class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def authenticate_user!
    redirect_to "/login", alert: "You must be logged in." unless logged_in?
  end

  def require_admin!
    redirect_to "/profile", alert: "Access denied." unless current_user&.role == "admin"
  end
end
