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
RecipeIngredient.destroy_all
Recipe.destroy_all
User.destroy_all
Ingredient.destroy_all


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

guacamole = Recipe.create(name: "Guacamole", instructions: "Mash the flesh of ripe avocados with a fork until smooth, then mix in lime juice, diced tomatoes, chopped onions, and fresh cilantro.", cuisine: "Mexican", image_url: "https://www.simplyrecipes.com/thmb/J4kA2m6jKMgkQwZhG-RYpjZBeFQ=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Guacamole-LEAD-6-2-64cfcca253c8421dad4e3fad830219f6.jpg", cook_time: "30 minutes", difficulty: "easy")

ratatouille = Recipe.create(name: "Ratatouille", instructions: "Slice zucchini, eggplant, and tomatoes into thin rounds, then layer them in a baking dish with a tomato-based sauce. Drizzle with olive oil, season with herbs like thyme, and bake until tender and golden", cuisine: "French", image_url: "https://www.howtocook.recipes/wp-content/uploads/2021/05/Ratatouille-recipe.jpg", cook_time: "1hr 30 minutes", difficulty: "hard")

puts "Created #{Recipe.count} recipes."

puts "Creating ingredients..."

avocado = Ingredient.create(name: "Avocado", category: "Fruit", carbon_per_gram: 2.5)
RecipeIngredient.create(recipe: guacamole, ingredient: avocado, weight_in_grams: 200, quantity: 200, unit: "g")

tomato = Ingredient.create(name: "Tomato", category: "Vegetable", carbon_per_gram: 0.2)
RecipeIngredient.create(recipe: guacamole, ingredient: tomato, weight_in_grams: 50, quantity: 50, unit: "g")

onion = Ingredient.create(name: "Onion", category: "Vegetable", carbon_per_gram: 0.1)
RecipeIngredient.create(recipe: guacamole, ingredient: onion, weight_in_grams: 30, quantity: 30, unit: "g")

lime = Ingredient.create(name: "Lime", category: "Fruit", carbon_per_gram: 0.3)
RecipeIngredient.create(recipe: guacamole, ingredient: lime, weight_in_grams: 20, quantity: 20, unit: "g")

RecipeIngredient.create(recipe: ratatouille, ingredient: tomato, weight_in_grams: 200, quantity: 200, unit: "g")

courgette = Ingredient.create(name: "Courgette", category: "Vegetable", carbon_per_gram: 0.15)
RecipeIngredient.create(recipe: ratatouille, ingredient: courgette, weight_in_grams: 150, quantity: 150, unit: "g")

aubergine = Ingredient.create(name: "Aubergine", category: "Vegetable", carbon_per_gram: 0.25)
RecipeIngredient.create(recipe: ratatouille, ingredient: aubergine, weight_in_grams: 180, quantity: 180, unit: "g")

bell_pepper = Ingredient.create(name: "Bell Pepper", category: "Vegetable", carbon_per_gram: 0.3)
RecipeIngredient.create(recipe: ratatouille, ingredient: bell_pepper, weight_in_grams: 120, quantity: 120, unit: "g")

garlic = Ingredient.create(name: "Garlic", category: "Vegetable", carbon_per_gram: 0.1)
RecipeIngredient.create(recipe: ratatouille, ingredient: garlic, weight_in_grams: 10, quantity: 10, unit: "g")

puts "Created #{Ingredient.count} ingredients and #{RecipeIngredient.count} recipe ingredients."
