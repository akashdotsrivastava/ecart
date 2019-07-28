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