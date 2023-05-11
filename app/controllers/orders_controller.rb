class OrdersController < ApplicationController
  GRANULARITY_OPTIONS = [:day, :week, :month, :year].freeze
  def index
    return head :bad_request unless validate_dates

    orders = Order.includes(product: [:categories, :user])
    orders = apply_filters(orders, params)

    if params[:granularity].present? && GRANULARITY_OPTIONS.include?(params[:granularity].to_sym)
      return render json: orders.count_by_granularity(params[:granularity])
    end
    render json: orders, only: [:id, :customer_id, :price, :quantity], include:
    { product: { only: [:id, :title, :description, :price, :stock],
                 include: [:categories, :user] } }
  end

  def most_selled_products
    render json: CategoryOrdersQuery.most_selled_products
  end

  def most_collected_products
    render json: CategoryOrdersQuery.most_collected_products
  end

  private

  def validate_dates
    @from_date = Date.strptime(params[:from]) if params[:from].present?
    @to_date   = Date.strptime(params[:to]) if params[:to].present?
    true
  rescue ArgumentError
    false
  end

  def apply_filters(orders, params)
    # fecha de compra (desde y hasta)
    orders = orders.where('orders.created_at >= ?', @from_date) if @from_date.present?
    orders = orders.where('orders.created_at <= ?', @to_date.end_of_day) if @to_date.present?
    orders = orders.by_customer(params[:customer_id]) if params[:customer_id].present?
    orders = orders.by_category(params[:category_id]) if params[:category_id].present?
    orders = orders.by_user(params[:user_id]) if params[:user_id].present?
    orders
  end
end
