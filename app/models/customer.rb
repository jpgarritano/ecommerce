class Customer < ActiveRecord::Base
  has_many :orders
  attr_accessible :email, :first_name, :last_name
end
