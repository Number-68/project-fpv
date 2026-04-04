class SessionsController < ApplicationController
  def create
    customer = Customer.find_by(email: params[:email])
    if customer && customer.authenticate(params[:password])
      session[:customer_id] = customer.id
      redirect_to root_path, notice: "Logged in successfully."
    else
      flash.now[:alert] = "Invalid email or password"
      render "pages/login_signup"
    end
  end

  def destroy
    session.delete(:customer_id)
    redirect_to root_path, notice: "Logged out."
  end
end
