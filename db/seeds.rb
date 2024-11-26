
require "json"
require "open-uri"
require 'uri'
require 'net/http'

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

# API request for recipes
url = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/complexSearch\?offset\=0\&number\=46"
recipes_serialized = URI.open(
  url,
  "x-rapidapi-key" => 'fd2411960bmsh4b56087a6e0b8e1p1a1c6ejsn0af91bca7bfc',
  "x-rapidapi-host" => 'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com'
).read
recipes = JSON.parse(recipes_serialized)

# API request to fill information for each individual recipe

# recipes["results"].each do |recipe|
  id_url = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/715415/information"
  recipe_ids_serialized = URI.open(
    id_url,
    "x-rapidapi-key" => 'fd2411960bmsh4b56087a6e0b8e1p1a1c6ejsn0af91bca7bfc',
    "x-rapidapi-host" => 'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com'
  ).read
  recipe_info = JSON.parse(recipe_ids_serialized)

  # p recipe_info["extendedIngredients"]

  # seeding recipes
  new_recipe = {
    name: recipe_info["title"],
    instructions: recipe_info["instructions"],
    image_url: recipe_info["image"],
    cook_time: recipe_info["cookingMinutes"],
    difficulty: ["easy", "medium", "hard"].sample
  }

  recipe = Recipe.create!(new_recipe)

  # # seeding ingredients
  recipe_info["extendedIngredients"].each do |ingredient|
    found_ingredient = Ingredient.find_by_name("#{ingredient["nameClean"]}")
    carbon_array = {
      "chicken" => 9.87,
      "beef" => 99.48,
      "lamb" => 39.72,
      "prawn" => 26.87,
      "cheese" => 23.88,
      "pork" => 12.31,
      "egg" => 4.67,
      "rice" => 4.45,
      "milk" => 3.15,
      "tomato" => 2.09
    }

    serving = ingredient["measures"]["metric"]["unit"] == "" ? "servings" : ingredient["measures"]["metric"]["unit"]
    if found_ingredient
      RecipeIngredient.create(
        ingredient: ingredient,
        recipe: recipe,
        quantity: ingredient["amount"],
        unit: serving
        )
    else
      carbon_value = carbon_array[ingredient["nameClean"]] || 2.5
      new_ingredient = Ingredient.create(
        name: ingredient["nameClean"],
        category: ingredient["aisle"],
        carbon_per_gram: carbon_value
      )

      RecipeIngredient.create(
        ingredient: new_ingredient,
        recipe: recipe,
        quantity: ingredient["amount"],
        unit: serving
        )
    end
  end
