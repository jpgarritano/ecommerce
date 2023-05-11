FactoryBot.define do
  factory :product do
    title { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    type { "" }
    stock { 10 }
    user
    categories { [association(:category)] }
    price { 100 }
  end
end
