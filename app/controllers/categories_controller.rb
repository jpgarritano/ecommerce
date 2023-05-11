class CategoriesController < ApplicationController
  before_filter :set_paper_trail_whodunnit, only: [:update]
  before_filter :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.order('name asc')
                          .paginate(page: params[:page] || 1, per_page: 15)
    respond_with(@categories)
  end

  def show
    respond_with(@category)
  end

  def new
    @category = Category.new
    respond_with(@category)
  end

  def edit
  end

  def create
    @category = Category.new(params[:category])
    @category.user = @current_user
    @category.save
    respond_with(@category)
  end

  def update
    @category.update_attributes(params[:category])
    respond_with(@category)
  end

  def destroy
    @category.destroy
    respond_with(@category)
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def set_creator
    @category.user = @current_user
  end
end
