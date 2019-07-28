# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

item_a = Item.find_or_create_by(name: 'A', price: 30.0)
item_b = Item.find_or_create_by(name: 'B', price: 20.0)
item_c = Item.find_or_create_by(name: 'C', price: 50.0)
item_d = Item.find_or_create_by(name: 'D', price: 15.0)

cart_1 = Cart.first || Cart.create
cart_2 = Cart.second || Cart.create
cart_3 = Cart.third || Cart.create
cart_4 = Cart.fourth || Cart.create

ItemDiscount.find_or_create_by(item: item_a, quantity: 3, discount: 15.0)
ItemDiscount.find_or_create_by(item: item_b, quantity: 2, discount: 5.0)

CartDiscount.find_or_create_by(total_basket_price: 150.0, additional_discount: 20.0)

[item_a, item_b, item_c].each do |item|
  ItemsCart.find_or_create_by(cart: cart_1, item: item)
end

[item_b, item_a, item_b, item_a, item_a].each do |item|
  ItemsCart.find_or_create_by(cart: cart_2, item: item)
end

[item_c, item_b, item_a, item_a, item_d, item_a, item_b].each do |item|
  ItemsCart.find_or_create_by(cart: cart_3, item: item)
end

[item_c, item_a, item_d, item_a, item_a].each do |item|
  ItemsCart.find_or_create_by(cart: cart_4, item: item)
end