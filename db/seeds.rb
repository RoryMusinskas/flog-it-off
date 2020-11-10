# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Seeding the categories for the app
Category.create([{ name: 'Doors' }, { name: 'Electrical' }, { name: 'Fixtures' }, { name: 'Flooring' }, { name: 'Masonry' }, { name: 'Plaster' }, { name: 'Plumbing' }, { name: 'Roofing' }, { name: 'Timber' }, { name: 'Windows' }])

# seeding fake seller accounts
# 5.times do
#     email = Faker::Internet.email,
#     password = 'password',
#     role = 'seller',
#     first_name = Faker::Name.first_name,
#     last_name = Faker::Name.last_name,
#     time_zone = 'Melbourne'
#     User.create! email: email, password: password, role: role, first_name: first_name, last_name: last_name, time_zone: time_zone
# end

# # seeding fake buyer accounts
# 5.times do
#     email = Faker::Internet.email,
#     password = 'password',
#     role = 'buyer',
#     first_name = Faker::Name.first_name,
#     last_name = Faker::Name.last_name,
#     time_zone = 'Melbourne'
#     User.create email: email, password: password, role: role, first_name: first_name, last_name: last_name, time_zone: time_zone
# end

# # Seeding for random collection data
# 20.times do 
#   name = Faker::Lorem.words(number: 1), 
#     description = Faker::Company.bs, 
#     price = rand(1..1000), 
#     quantity = rand(1..200), 
#     available_until = Faker::Time.forward(days: 2, period: :evening), 
#     longitude = rand(140.6..150.3), 
#     latitude = rand(-38.0..-33.8), 
#     seller_id = rand(1..5), 
#     available_hours_morning = rand(0..12), 
#     available_hours_night = rand(0..9),
#     image = Faker::LoremFlickr.image
#     Collection.create! name: name, description: description, price: price, quantity: quantity, available_until: available_until, longitude: longitude, latitude: latitude, seller_id: seller_id, available_hours_morning: available_hours_morning, available_hours_night: available_hours_night
# end
