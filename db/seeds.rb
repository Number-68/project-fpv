# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#AdminUser.create!(email: 'admin@fpvshop.com', password: 'fpvworldrules!', password_confirmation: 'fpvworldrules!') if Rails.env.development?


5.times do
  Category.create!(
    name: Faker::Commerce.unique.department(max: 1) 
  )
end


100.times do
  Product.create!(
    name: Faker::Commerce.product_name,
    brand: Faker::Company.name,
    description: Faker::Lorem.paragraph,
    price: Faker::Commerce.price(range: 10..300),
    sku: Faker::Alphanumeric.alphanumeric(number: 8).upcase,
    stock: Faker::Number.between(from: 5, to: 50),
    category: Category.all.sample,
    image_url: "test/BikeYo.jpg"
  )
end