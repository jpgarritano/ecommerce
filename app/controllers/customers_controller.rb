class CustomersController < ApplicationController
  before_filter :set_customer, only: [:show, :edit, :update, :destroy]

  respond_to :json

  def index
    @customers = Customer.order('email asc')
                         .paginate(page: params[:page] || 1, per_page: 15)
    respond_with(@customers)
  end

  def show
    respond_with(@customer)
  end

  def new
    @customer = Customer.new
    respond_with(@customer)
  end

  def edit
  end

  def create
    @customer = Customer.new(params[:customer])
    @customer.save
    respond_with(@customer)
  end

  def update
    @customer.update_attributes(params[:customer])
    respond_with(@customer)
  end

  def destroy
    @customer.destroy
    respond_with(@customer)
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end
end
