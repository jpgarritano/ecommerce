FactoryBot.define do
  factory :order do
    customer
    product
    price { product.price }
    quantity { 1 }
  end
end
