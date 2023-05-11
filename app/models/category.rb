class Category < ActiveRecord::Base
  has_paper_trail on: [:update, :destroy]
  belongs_to :user
  has_many :category_products
  has_many :products, through: :category_products, dependent: :destroy

  attr_accessible :name, :products_attributes

  accepts_nested_attributes_for :products, allow_destroy: true

  validates :name, presence: true
  validates :name, uniqueness: true

  def to_s
    name
  end

  def self.most_selled_products
    CategoryOrdersQuery.most_selled_products
  end

  def self.most_collected_products
    CategoryOrdersQuery.most_collected_products
  end
end
