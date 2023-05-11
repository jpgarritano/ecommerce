# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user =  User.create(email:"admin@puntospoint.com", password: '123123', password_confirmation: '123123')
customer = Customer.create(email: 'cliente@gmail.com')
Category.create(name: "Hogar")
Category.create(name: "Electro")
Category.create(name: "Deportes")
Category.create(name: "Tecno")

10.times do |i|
  Product.create(
    {title: "Producto #{i+1}",
     description: "",
     stock: 10,
     price: 10 * (i+1),
     categories: [Category.find(rand(4)+1)],
     user: user},
    without_protection: true)
end

products = Product.all

15.times do |i|
  product = products.sample
  Order.create(product: product, customer: customer, price: product.price, quantity: 1)
end
