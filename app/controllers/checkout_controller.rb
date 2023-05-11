class CheckoutController < ApplicationController
  skip_before_filter :authenticate

  def confirm
    @product = Product.find(params[:product_id])
    if @product.stock > 0
      first_purchase = !Order.exists?(product_id: @product.id)
      confirm_order!

      send_notifications if first_purchase
      head :ok
    else
      render json: { error: "No stock for #{@product.title}" }, status: :unprocessable_entity
    end
  end

  private

  def confirm_order!
    @customer = Customer.where(email: params[:email]).first_or_create
    @order = Order.create!(customer: @customer,
                           product: @product,
                           price: @product.price,
                           quantity: params[:quantity] || 1)
    @product.stock -= 1
    @product.save
  end

  def send_notifications
    OrderMailer.first_product_purchase(@order).deliver
  end
end
