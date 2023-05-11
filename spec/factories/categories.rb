FactoryBot.define do
  factory :category do
    # Version antigua de factorybot no soporta metodo .unique
    name { "#{Faker::Lorem.word} #{rand 10000}" }
  end
end
