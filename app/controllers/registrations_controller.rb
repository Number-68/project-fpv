class RegistrationsController < ApplicationController
  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      session[:customer_id] = @customer.id
      redirect_to root_path, notice: "Account created successfully."
    else
      flash.now[:alert] = @customer.errors.full_messages.to_sentence
      render "pages/login_signup"
    end
  end



  private

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :password, :password_confirmation, :phone_number, :address)
  end


end
