class OrdersController < ApplicationController
  before_action :require_login, only: [ :new, :create, :show ]



  def success
    session_id = params[:session_id]
    # get chckout data from stripe
    checkout_session = Stripe::Checkout::Session.retrieve(session_id)

    if checkout_session.payment_status == "paid"
      # meta data
      metadata = checkout_session.metadata
      cart_data = JSON.parse(metadata["cart_data"])
      customer_id = metadata["customer_id"]

      # order attributes
      order = Order.new(
        customer_id: customer_id,
        status: "paid",
        order_date: Time.current,
        shipping_address_line1: metadata["shipping_address_line1"],
        shipping_address_line2: metadata["shipping_address_line2"],
        shipping_city: metadata["shipping_city"],
        shipping_postal_code: metadata["shipping_postal_code"],
        shipping_province: metadata["shipping_province"],
        subtotal: metadata["subtotal"].to_d,
        gst: metadata["tax"].to_d * 0.5,
        pst: metadata["tax"].to_d * 0.5,
        total_price: metadata["total"].to_d
      )

      if order.save
        # create order item
        cart_data.each do |product_id, quantity|
          product = Product.find_by(id: product_id)
          next unless product
          order.order_items.create!(
            product: product,
            quantity: quantity,
            unit_price: product.price
          )
        end

        # clear cart data  from session
        session.delete(:cart)

        flash[:notice] = "Order placed successfully!"
        redirect_to order
      else
        flash[:error] = "Could not save order."
        redirect_to root_path
      end
    else
      flash[:error] = "Payment was not completed."
      redirect_to cart_path
    end
  end






  def cancel
    flash[:error] = "Payment cancelled."
    redirect_to cart_path
  end




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
    cart = session[:cart] || {}
    if cart.empty?
      redirect_to cart_path, alert: "Your cart is empty." and return
    end

    subtotal = 0
    cart_items = cart.map do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product
      subtotal += product.price * quantity
      {
        product_id: product.id,
        quantity: quantity,
        unit_price: product.price,
        total: product.price * quantity
      }
    end.compact

    tax_rate = 0.12
    tax = subtotal * tax_rate
    total = subtotal + tax
    total_cents = (total * 100).to_i

    line_items = [ {
      price_data: {
        currency: "usd",
        product_data: {
          name: "FPV Order",
          description: "Order from #{current_customer.email}"
        },
        unit_amount: total_cents
      },
      quantity: 1
    } ]

    metadata = {
      cart_data: cart.to_json,
      customer_id: current_customer.id,
      shipping_address_line1: params[:order][:shipping_address_line1],
      shipping_address_line2: params[:order][:shipping_address_line2],
      shipping_city: params[:order][:shipping_city],
      shipping_postal_code: params[:order][:shipping_postal_code],
      shipping_province: params[:order][:shipping_province],
      subtotal: subtotal.to_s,
      tax: tax.to_s,
      total: total.to_s
    }

    begin
      stripe_session = Stripe::Checkout::Session.create(
        payment_method_types: [ "card" ],
        line_items: line_items,
        mode: "payment",
        success_url: "#{request.base_url}/orders/success?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: order_cancel_url,
        metadata: metadata,
      )

      redirect_to stripe_session.url, allow_other_host: true

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to cart_path
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
