class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  
  def current_customer
    @current_customer ||= Customer.find_by(id: session[:customer_id]) if session[:customer_id]
  end

  def logged_in?
    current_customer.present?
  end

  def require_login
    unless logged_in?
      redirect_to login_signup_path, alert: "Please log in to continue."
    end
  end
end
