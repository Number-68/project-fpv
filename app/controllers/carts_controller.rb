class CartsController < ApplicationController
  before_action :require_login, only: [ :show, :add, :remove, :update ]


  def show
    @cart = session[:cart] || {}
  end

  # post
  def add
    product_id = params[:product_id].to_s
    cart = session[:cart] || {}
    cart[product_id] = cart[product_id].to_i + 1
    session[:cart] = cart
    redirect_back(fallback_location: cart_path, notice: "Item added to cart")
  end

  # delete
  def remove
    product_id = params[:product_id].to_s
    cart = session[:cart] || {}
    cart.delete(product_id)
    session[:cart] = cart
    redirect_back(fallback_location: cart_path, notice: "Item removed")
  end

  # update
  def update
    product_id = params[:product_id].to_s
    cart = session[:cart] || {}
    new_quantity = params[:quantity].to_i
    if new_quantity > 0
      cart[product_id] = new_quantity
    else
      cart.delete(product_id)
    end
    session[:cart] = cart
    redirect_back(fallback_location: cart_path, notice: "Cart updated")
  end
end
