class Dimention < ActiveRecord::Base
  belongs_to :product, dependent: :destroy

  validates :product, presence: true
  attr_accessible :height, :weight, :width
end
