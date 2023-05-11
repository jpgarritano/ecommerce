class Product < ActiveRecord::Base
  has_paper_trail on: [:update, :destroy]
  belongs_to :user
  has_one :dimention
  has_many :images, dependent: :destroy
  has_many :orders, dependent: :restrict

  validates :title, :user, :categories, presence: true

  has_many :category_products
  has_many :categories, through: :category_products, dependent: :destroy
  accepts_nested_attributes_for :categories, allow_destroy: true

  attr_accessible :title, :description, :stock, :price,
                  :type, :categories_attributes

  before_validation :find_or_create_categories

  def find_or_create_categories
    self.categories = categories.map do |category|
      Category.where(name: category.name).first_or_create
    end
  end

  def to_s
    title
  end
end
