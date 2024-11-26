# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Cleaning database..."
Recipe.destroy_all
User.destroy_all

puts "Creating users..."
adam = User.create(
  first_name: "Adam",
  last_name: "Jones",
  email: "adam@jones.com",
  password: "password"
)

ellie = User.create!(
  first_name: "Ellie",
  last_name: "Stevens",
  email: "ellie@stevens.com",
  password: "password"
)

puts "Created #{User.count} users."

puts "Creating recipes..."

Recipe.create(name: "Guacamole", instructions: "Mash the flesh of ripe avocados with a fork until smooth, then mix in lime juice, diced tomatoes, chopped onions, and fresh cilantro.", cuisine: "Mexican", image_url: "https://www.simplyrecipes.com/thmb/J4kA2m6jKMgkQwZhG-RYpjZBeFQ=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Guacamole-LEAD-6-2-64cfcca253c8421dad4e3fad830219f6.jpg", cook_time: "30 minutes", difficulty: "easy")

Recipe.create(name: "Ratatouille", instructions: "Slice zucchini, eggplant, and tomatoes into thin rounds, then layer them in a baking dish with a tomato-based sauce. Drizzle with olive oil, season with herbs like thyme, and bake until tender and golden", cuisine: "French", image_url: "https://www.howtocook.recipes/wp-content/uploads/2021/05/Ratatouille-recipe.jpg", cook_time: "1hr 30 minutes", difficulty: "hard")

puts "Created #{Recipe.count} users."
