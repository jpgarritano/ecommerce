class Image < ActiveRecord::Base
  belongs_to :product
  attr_accessible :order
end
