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

# API URL for recipes

url = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/complexSearch\?offset\=0\&number\=20"

# Creating a recipes file

recipes_filename = "db/files/recipe_list.json"
if File.exist?(recipes_filename)
  puts "File exists, using that..."
  recipes = JSON.parse(File.open(recipes_filename, "r").read)
else
  puts "Fetching recipes from API..."
  recipes_serialized = URI.open(
    url,
    "x-rapidapi-key" => 'fd2411960bmsh4b56087a6e0b8e1p1a1c6ejsn0af91bca7bfc',
    "x-rapidapi-host" => 'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com'
  ).read
  recipes = JSON.parse(recipes_serialized)
  File.open(recipes_filename, "w") do |f|
    f.write(JSON.pretty_generate(recipes))
  end
end

# API request to fill information for each individual recipe

recipes["results"].each do |recipe|
  id_url = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/#{recipe["id"]}/information"

  # Creating a recipe file

  recipe_filename = "db/files/recipes/#{recipe["id"]}.json"
  if File.exist?(recipe_filename)
    puts "File exists, using that..."
    recipe_info = JSON.parse(File.open(recipe_filename, "r").read)
  else
    puts "Fetching recipe from API..."
    recipe_ids_serialized = URI.open(
      id_url,
      "x-rapidapi-key" => 'fd2411960bmsh4b56087a6e0b8e1p1a1c6ejsn0af91bca7bfc',
      "x-rapidapi-host" => 'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com'
    ).read
    recipe_info = JSON.parse(recipe_ids_serialized)
    File.open(recipe_filename, "w") do |f|
      f.write(JSON.pretty_generate(recipe_info))
    end
  end

  # seeding recipes

  new_recipe = {
    name: recipe_info["title"],
    instructions: recipe_info["instructions"],
    image_url: recipe_info["image"],
    cook_time: recipe_info["cookingMinutes"],
    difficulty: ["easy", "medium", "hard"].sample
  }

  recipe = Recipe.create!(new_recipe)

  # seeding ingredients
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

    serving = ingredient["measures"]["metric"]["unitShort"] == "" ? "servings" : ingredient["measures"]["metric"]["unitShort"]

    if found_ingredient
      puts "Found ingredient already"
      p found_ingredient
      RecipeIngredient.create(
        ingredient: found_ingredient,
        recipe: recipe,
        quantity: ingredient["amount"],
        unit: serving
        )
    else
      puts "Creating new ingredient"
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
end

Recipe.find_by(name: "Red Lentil Soup with Chicken and Turnips")&.update(cuisine: "French", image_url: "https://www.jocooks.com/wp-content/uploads/2020/07/red-lentil-chicken-soup-1-3.jpg")

Recipe.find_by(name: "Asparagus and Pea Soup: Real Convenience Food")&.update(name: "Asparagus and Pea Soup", cuisine: "British", image_url: "https://static01.nyt.com/images/2017/02/28/dining/28COOKING-ROASTASPARAGUS-SOUP1/28COOKING-ROASTASPARAGUS-SOUP1-superJumbo.jpg")

Recipe.find_by(name: "Garlicky Kale")&.update(cuisine: "British", image_url: "https://www.allrecipes.com/thmb/A5OQPKqZ0YzXB5Drz8RCf4Zg-LA=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/241074-easy-garlic-kale-DDMFS-4x3-d90afb55e21a4d6bb2da0198b87523da.jpg")

Recipe.find_by(name: "Slow Cooker Beef Stew")&.update(cuisine: "French", image_url: "https://www.cookingclassy.com/wp-content/uploads/2017/10/slow-cooker-beef-stew-13.jpg")

Recipe.find_by(name: "Red Kidney Bean Jambalaya")&.update(cuisine: "American", image_url: "https://www.abbeyskitchen.com/wp-content/uploads/2022/07/Vegan-Jambalay-1.jpg")

Recipe.find_by(name: "Cauliflower, Brown Rice, and Vegetable Fried Rice")&.update(cuisine: "Thai", image_url: "https://www.wellplated.com/wp-content/uploads/2016/06/Pineapple-Healthy-Fried-Rice.jpg")

Recipe.find_by(name: "Quinoa and Chickpea Salad with Sun-Dried Tomatoes and Dried Cherries")&.update(name: "Quinoa and Chickpea Salad", cuisine: "Mediterranean", image_url: "https://www.lastingredient.com/wp-content/uploads/2021/08/quinoa-chickpea-salad5.jpg")

Recipe.find_by(name: "Easy Homemade Rice and Beans")&.update(cuisine: "Latin American", image_url: "https://www.realthekitchenandbeyond.com/wp-content/uploads/2016/10/Rice-and-Beans-Tasty.jpg")

Recipe.find_by(name: "Tuscan White Bean Soup with Olive Oil and Rosemary")&.update(cuisine: "Mediterranean", image_url: "https://www.feastingathome.com/wp-content/uploads/2015/10/ribollita-111.jpg")

Recipe.find_by(name: "Crunchy Brussels Sprouts Side Dish")&.update(cuisine: "American", image_url: "https://www.paleorunningmomma.com/wp-content/uploads/2022/04/smashed-brussels-sprouts-8.jpg")

Recipe.find_by(name: "Slow Cooker: Pork and Garbanzo Beans")&.update(cuisine: "Mediterranean", image_url: "https://food-images.files.bbci.co.uk/food/recipes/pork_and_chickpea_stew_81433_16x9.jpg")

Recipe.find_by(name: "Powerhouse Almond Matcha Superfood Smoothie")&.update(cuisine: "Japanese", image_url: "https://www.totalbodynourishment.com/wp-content/uploads/2016/01/rsz_dollarphotoclub_77758629.jpg")

Recipe.find_by(name: "Broccolini Quinoa Pilaf")&.update(cuisine: "Mediterranean", image_url: "https://www.happyheartedkitchen.com/wp-content/uploads/2015/02/IMG_6176_.jpg")


puts "Created #{Recipe.count} recipes, #{Ingredient.count} ingredients and #{RecipeIngredient.count} recipe ingredients."


# puts "Creating recipes..."

# guacamole = Recipe.create(name: "Guacamole", instructions: "Mash the flesh of ripe avocados with a fork until smooth, then mix in lime juice, diced tomatoes, chopped onions, and fresh cilantro.", cuisine: "Mexican", image_url: "https://www.simplyrecipes.com/thmb/J4kA2m6jKMgkQwZhG-RYpjZBeFQ=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Guacamole-LEAD-6-2-64cfcca253c8421dad4e3fad830219f6.jpg", cook_time: "30 minutes", difficulty: "easy")

# ratatouille = Recipe.create(name: "Ratatouille", instructions: "Slice zucchini, eggplant, and tomatoes into thin rounds, then layer them in a baking dish with a tomato-based sauce. Drizzle with olive oil, season with herbs like thyme, and bake until tender and golden", cuisine: "French", image_url: "https://www.howtocook.recipes/wp-content/uploads/2021/05/Ratatouille-recipe.jpg", cook_time: "1hr 30 minutes", difficulty: "hard")

# puts "Created #{Recipe.count} recipes."

# puts "Creating ingredients..."

# avocado = Ingredient.create(name: "Avocado", category: "Fruit", carbon_per_gram: 2.5)
# RecipeIngredient.create(recipe: guacamole, ingredient: avocado, weight_in_grams: 200, quantity: 200, unit: "g")

# tomato = Ingredient.create(name: "Tomato", category: "Vegetable", carbon_per_gram: 0.2)
# RecipeIngredient.create(recipe: guacamole, ingredient: tomato, weight_in_grams: 50, quantity: 50, unit: "g")

# onion = Ingredient.create(name: "Onion", category: "Vegetable", carbon_per_gram: 0.1)
# RecipeIngredient.create(recipe: guacamole, ingredient: onion, weight_in_grams: 30, quantity: 30, unit: "g")

# lime = Ingredient.create(name: "Lime", category: "Fruit", carbon_per_gram: 0.3)
# RecipeIngredient.create(recipe: guacamole, ingredient: lime, weight_in_grams: 20, quantity: 20, unit: "g")

# RecipeIngredient.create(recipe: ratatouille, ingredient: tomato, weight_in_grams: 200, quantity: 200, unit: "g")

# courgette = Ingredient.create(name: "Courgette", category: "Vegetable", carbon_per_gram: 0.15)
# RecipeIngredient.create(recipe: ratatouille, ingredient: courgette, weight_in_grams: 150, quantity: 150, unit: "g")

# aubergine = Ingredient.create(name: "Aubergine", category: "Vegetable", carbon_per_gram: 0.25)
# RecipeIngredient.create(recipe: ratatouille, ingredient: aubergine, weight_in_grams: 180, quantity: 180, unit: "g")

# bell_pepper = Ingredient.create(name: "Bell Pepper", category: "Vegetable", carbon_per_gram: 0.3)
# RecipeIngredient.create(recipe: ratatouille, ingredient: bell_pepper, weight_in_grams: 120, quantity: 120, unit: "g")

# garlic = Ingredient.create(name: "Garlic", category: "Vegetable", carbon_per_gram: 0.1)
# RecipeIngredient.create(recipe: ratatouille, ingredient: garlic, weight_in_grams: 10, quantity: 10, unit: "g")
