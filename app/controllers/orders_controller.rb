class OrdersController < ApplicationController
  before_action :require_login, only: [:new, :create, :show]

  def new
    @cart = session[:cart] || {}
    if @cart.empty?
      redirect_to cart_path, alert: "Your cart is empty." and return
    end

    @cart_items = @cart.map do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product
      {
        product: product,
        quantity: quantity,
        unit_price: product.price,
        total: product.price * quantity
      }
    end.compact

    @subtotal = @cart_items.sum { |item| item[:total] }
    @tax_rate = 0.12
    @tax = @subtotal * @tax_rate
    @total = @subtotal + @tax

    @order = Order.new
  end

  def create
    @cart = session[:cart] || {}
    if @cart.empty?
      redirect_to cart_path, alert: "Your cart is empty." and return
    end

    @cart_items = @cart.map do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product
      {
        product: product,
        quantity: quantity,
        unit_price: product.price,
        total: product.price * quantity
      }
    end.compact

    subtotal = @cart_items.sum { |item| item[:total] }
    tax_rate = 0.12
    tax = subtotal * tax_rate
    total = subtotal + tax

    @order = Order.new(order_params)
    @order.customer = current_customer
    @order.order_date = Time.current
    @order.status = "pending"
    @order.subtotal = subtotal
    @order.gst = tax * 0.5
    @order.pst = tax * 0.5
    @order.total_price = total

    if @order.save
      @cart_items.each do |item|
        @order.order_items.create!(
          product: item[:product],
          quantity: item[:quantity],
          unit_price: item[:unit_price]
        )
      end
      session.delete(:cart)
      redirect_to @order, notice: "Order placed successfully!"
    else
  
      @cart_items = @cart_items
      @subtotal = subtotal
      @tax = tax
      @total = total
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(
      :shipping_address_line1,
      :shipping_address_line2,
      :shipping_city,
      :shipping_postal_code,
      :shipping_province
    )
  end
end