require "json"
require "open-uri"
require 'uri'
require 'net/http'

puts "Cleaning database..."
Meal.destroy_all
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

url = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/complexSearch\?offset\=0\&number\=80"

# Creating a recipes file

recipes_filename = "db/files/recipe_list.json"
if File.exist?(recipes_filename)
  puts "File exists, using that..."
  recipes = JSON.parse(File.open(recipes_filename, "r").read)
else
  puts "Fetching recipes from API..."
  recipes_serialized = URI.open(
    url,
    "x-rapidapi-key" => ENV['SPOONACULAR_API_KEY'],
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
      "x-rapidapi-key" => ENV['SPOONACULAR_API_KEY'],
      "x-rapidapi-host" => 'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com'
    ).read
    recipe_info = JSON.parse(recipe_ids_serialized)
    File.open(recipe_filename, "w") do |f|
      f.write(JSON.pretty_generate(recipe_info))
    end
  end

  # seeding recipes
  instruction_steps = []
  recipe_info["analyzedInstructions"].each do |step|
    step["steps"].each do |instruction_step|
    instruction_steps << "#{instruction_step["number"]}. #{instruction_step["step"]}\n\n"
    end
  end

  new_recipe = {
    name: recipe_info["title"],
    instructions: instruction_steps.join,
    image_url: recipe_info["image"],
    cook_time: "#{recipe_info["readyInMinutes"]} minutes",
    difficulty: ["easy", "medium", "hard"].sample,
    servings: recipe_info["servings"]
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
      "tomato" => 2.09,
      "italian tomato" => 2.09,
      "avocado" => 0.28,
      "red pepper" => 0.11,
      "garlic" => 0.5,
      "carrot" => 0.38,
      "onion" => 0.11,
      "celery" => 0.27,
      "vegetable stock" => 3.01,
      "spring onions" => 0.32,
      "cooked brown rice" => 4.03,
      "petite peas" => 0.58,
      "canned tomatoes" => 0.75,
      "cumin" => 1.04,
      "black pepper" => 9.1,
      "olive oil" => 3.06,
      "table salt" => 0.23,
      "honey" => 0.34,
      "dried chickpeas" => 0.4,
      "kale" => 0.61,
      "quinoa" => 50.23,
      "asparagus" => 1.1,
      "dried porcini mushrooms" => 3.31,
      "dried white beans" => 1.29,
      "sun dried tomatoes" => 0.63,
      "broccoli" => 0.62,
      "eggplant" => 0.07,
      "mango" => 1.91,
      "chicken stock" => 5.04,
      "cinnamon" => 2.08,
      "couscous" => 1.32,
      "parsley" => 0.61,
      "water" => 0.31,
      "potato" => 0.29,
      "habanero chili" => 2.85,
      "cilantro" => 0.68,
      "red onion" => 0.11,
      "almonds" => 1.92,
      "plain yoghurt" => 3.09,
      "lemon juice" => 1.55,
      "lime juice" => 1.55,
      "shallot" => 0.61,
      "strawberries" => 0.28,
      "cauliflower" => 0.61,
      "salmon fillets" => 7.51,
      "butternut squash" => 0.27
    }

    serving = ingredient["measures"]["metric"]["unitShort"] == "" ? "servings" : ingredient["measures"]["metric"]["unitShort"]

    if found_ingredient
      puts "Found ingredient already"
      p found_ingredient
      RecipeIngredient.create(
        ingredient: found_ingredient,
        recipe: recipe,
        quantity: ingredient["measures"]["metric"]["amount"],
        unit: serving
        )
    else
      puts "Creating new ingredient"
      carbon_value = carbon_array[ingredient["nameClean"]] || 0.95
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

Recipe.find_by(name: "Red Lentil Soup with Chicken and Turnips")&.update(cuisine: "French", image_url: "https://www.jocooks.com/wp-content/uploads/2020/07/red-lentil-chicken-soup-1-3.jpg", difficulty: "hard")

Recipe.find_by(name: "Asparagus and Pea Soup: Real Convenience Food")&.update(name: "Asparagus and Pea Soup", cuisine: "British", image_url: "https://static01.nyt.com/images/2017/02/28/dining/28COOKING-ROASTASPARAGUS-SOUP1/28COOKING-ROASTASPARAGUS-SOUP1-superJumbo.jpg", difficulty: "easy")

Recipe.find_by(name: "Garlicky Kale")&.update(cuisine: "British", image_url: "https://www.allrecipes.com/thmb/A5OQPKqZ0YzXB5Drz8RCf4Zg-LA=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/241074-easy-garlic-kale-DDMFS-4x3-d90afb55e21a4d6bb2da0198b87523da.jpg", difficulty: "easy")

Recipe.find_by(name: "Slow Cooker Beef Stew")&.update(cuisine: "French", image_url: "https://www.southernliving.com/thmb/JkRFMLTdgwNq7nSwygu-mKL-5_Q=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Slow-Cooker-Beef-Stew-3x4-213-27e9373ecbc443b3a46337a83600fa49.jpg", difficulty: "hard")

Recipe.find_by(name: "Red Kidney Bean Jambalaya")&.update(cuisine: "American", image_url: "https://www.abbeyskitchen.com/wp-content/uploads/2022/07/Vegan-Jambalay-1.jpg", difficulty: "medium")

Recipe.find_by(name: "Cauliflower, Brown Rice, and Vegetable Fried Rice")&.update(cuisine: "Thai", image_url: "https://www.wellplated.com/wp-content/uploads/2016/06/Pineapple-Healthy-Fried-Rice.jpg", difficulty: "easy")

Recipe.find_by(name: "Quinoa and Chickpea Salad with Sun-Dried Tomatoes and Dried Cherries")&.update(name: "Quinoa and Chickpea Salad", cuisine: "Mediterranean", image_url: "https://www.lastingredient.com/wp-content/uploads/2021/08/quinoa-chickpea-salad5.jpg", difficulty: "medium")

Recipe.find_by(name: "Easy Homemade Rice and Beans")&.update(cuisine: "Latin American", image_url: "https://www.realthekitchenandbeyond.com/wp-content/uploads/2016/10/Rice-and-Beans-Tasty.jpg", difficulty: "easy")

Recipe.find_by(name: "Tuscan White Bean Soup with Olive Oil and Rosemary")&.update(cuisine: "Mediterranean", image_url: "https://www.feastingathome.com/wp-content/uploads/2015/10/ribollita-111.jpg", difficulty: "medium")

Recipe.find_by(name: "Crunchy Brussels Sprouts Side Dish")&.update(cuisine: "American", image_url: "https://www.paleorunningmomma.com/wp-content/uploads/2022/04/smashed-brussels-sprouts-8.jpg", difficulty: "easy")

Recipe.find_by(name: "Slow Cooker: Pork and Garbanzo Beans")&.update(cuisine: "Mediterranean", image_url: "https://food-images.files.bbci.co.uk/food/recipes/pork_and_chickpea_stew_81433_16x9.jpg", difficulty: "hard")

Recipe.find_by(name: "Powerhouse Almond Matcha Superfood Smoothie")&.update(cuisine: "Japanese", image_url: "https://www.totalbodynourishment.com/wp-content/uploads/2016/01/rsz_dollarphotoclub_77758629.jpg", difficulty: "medium")

Recipe.find_by(name: "Broccolini Quinoa Pilaf")&.update(cuisine: "Mediterranean", image_url: "https://www.happyheartedkitchen.com/wp-content/uploads/2015/02/IMG_6176_.jpg", difficulty: "medium")

Recipe.find_by(name: "Easy To Make Spring Rolls")&.update(cuisine: "Vietnamese", image_url: "https://www.allrecipes.com/thmb/QARzwdQYJx8YWlM0efKAfvPEdTE=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/3647841-a4a8dec2b679405783c48c26b6c41db8.jpg", difficulty: "easy")

Recipe.find_by(name: "Farro With Mushrooms and Asparagus")&.update(cuisine: "Italian", image_url: "https://www.twopeasandtheirpod.com/wp-content/uploads/2021/05/Spring-Farro-4.jpg", difficulty: "hard")

Recipe.find_by(name: "Butternut Squash Frittata")&.update(cuisine: "Spanish", image_url: "https://www.onceuponapumpkinrd.com/wp-content/uploads/2019/11/butternut-squash-frittata.jpg", difficulty: "medium")

Recipe.find_by(name: "Herbivoracious' White Bean and Kale Soup")&.update(cuisine: "Italian", image_url: "https://rainbowplantlife.com/wp-content/uploads/2020/01/white-bean-soup-recipe-card-1-of-1.jpg", difficulty: "medium")

Recipe.find_by(name: "Tomato and lentil soup")&.update(cuisine: "Middle Eastern", image_url: "https://feelgoodfoodie.net/wp-content/uploads/2022/04/Tomato-Lentil-Soup-8.jpg", difficulty: "easy")

Recipe.find_by(name: "Swiss Chard Wraps")&.update(cuisine: "Swiss", image_url: "https://images.food52.com/A3oZ0v9HCFh8GlRwOoTNzhA0Vdw=/2016x1344/filters:format(webp)/86eceac4-9780-42b8-be88-25f172234dd6--Asian_Style_Rainbow_Chard_Wraps-05.jpg", difficulty: "medium")

Recipe.find_by(name: "Corn Avocado Salsa")&.update(cuisine: "Mexican", image_url: "https://carlsbadcravings.com/wp-content/uploads/2019/07/avocado-corn-salsa-2d.jpg", difficulty: "medium")

Recipe.find_by(name: "Cheesy Chicken Enchilada Quinoa Casserole")&.update(cuisine: "Mexican", image_url: "https://www.averiecooks.com/wp-content/uploads/2016/01/chickenenchiladaquinoa-10.jpg", difficulty: "easy")

Recipe.find_by(name: "Zesty Green Pea and Jalapeño Pesto Pasta")&.update(cuisine: "Italian", image_url: "https://saltsugarspice.com/wp-content/uploads/2020/03/20200220_155928.jpg", difficulty: "easy")

Recipe.find_by(name: "Jade Buddha Salmon Tartare")&.update(cuisine: "Japanese", image_url: "https://media-cdn2.greatbritishchefs.com/media/hmojt5hm/img11436.jpg", difficulty: "hard")

Recipe.find_by(name: "Finger Foods: Frittata Muffins #incredibleEGG")&.update(name: "Frittata Muffins", cuisine: "Spanish", image_url: "https://www.thereciperebel.com/wp-content/uploads/2019/05/mini-frittata-muffins-www.thereciperebel.com-600-13-of-20.jpg", difficulty: "medium")

Recipe.find_by(name: "Spicy Black-Eyed Pea Curry with Swiss Chard and Roasted Eggplant")&.update(cuisine: "Indian", image_url: "https://strengthandsunshine.com/wp-content/uploads/2015/12/Black-Eyed-Pea-Curry-with-Swiss-Chard-Roasted-Eggplant-4.jpg", difficulty: "hard")

Recipe.find_by(name: "Moroccan chickpea and lentil stew")&.update(cuisine: "Moroccan", image_url: "https://www.crowdedkitchen.com/wp-content/uploads/2020/08/moroccan-chickpea-lentil-stew.jpg", difficulty: "easy")

Recipe.find_by(name: "Strawberry-Mango Quinoa Salad")&.update(cuisine: "Mediterranean", image_url: "https://www.jocooks.com/wp-content/uploads/2014/08/quinoa-salad-1-5.jpg", difficulty: "medium")

Recipe.find_by(name: "Caldo Verde - Portuguese Kale Soup")&.update(cuisine: "Portuguese", image_url: "https://www.oliviascuisine.com/wp-content/uploads/2023/01/caldo-verde.jpg", difficulty: "easy")

Recipe.find_by(name: "Moroccan Couscous and Chickpea Salad")&.update(cuisine: "Moroccan", image_url: "https://www.erinliveswhole.com/wp-content/uploads/2021/07/morrocan-couscous-salad-6.jpg", difficulty: "medium")

Recipe.find_by(name: "Easy Vegetable Beef Soup")&.update(cuisine: "American", image_url: "https://getonmyplate.com/wp-content/uploads/2021/10/vegetable-beef-soup-8.jpg", difficulty: "easy")

Recipe.find_by(name: "Mango Fried Rice")&.update(cuisine: "Thai", image_url: "https://makeitdairyfree.com/wp-content/uploads/2020/06/vegan-mango-fried-rice-2.jpg", difficulty: "medium")

Recipe.find_by(name: "Homemade Guacamole")&.update(cuisine: "Mexican", image_url: "https://www.maricruzavalos.com/wp-content/uploads/2010/09/mexican-authentic-guacamole-recipe.jpg", difficulty: "easy")

Recipe.find_by(name: "Spicy Salad with Kidney Beans, Cheddar, and Nuts")&.update(cuisine: "Mexican", image_url: "https://feelgoodfoodie.net/wp-content/uploads/2023/06/Chopped-Protein-Salad-06.jpg", difficulty: "medium")

Recipe.find_by(name: "Spicy Indian-Style Hummus")&.update(cuisine: "Indian", image_url: "https://cupfulofkale.com/wp-content/uploads/2019/04/Spicy-Piri-Piri-Hummus-2.jpeg", difficulty: "hard")

Recipe.find_by(name: "Roasted Broccoli with Lemon and Garlic")&.update(cuisine: "Mediterranean", image_url: "https://www.bowlofdelicious.com/wp-content/uploads/2019/09/Roasted-Broccoli-with-Garlic-and-Lemon-2.jpg", difficulty: "easy")

Recipe.find_by(name: "Stir Fried Quinoa, Brown Rice and Chicken Breast")&.update(cuisine: "Chinese", image_url: "https://media.self.com/photos/5a1c57547942e16e09b0575b/master/pass/Quinoa-Stir-Fry-Chicken.jpg", difficulty: "easy")

Recipe.find_by(name: "Amaranth and Roast Veggie Salad")&.update(cuisine: "Mediterranean", image_url: "https://www.deliciousmagazine.co.uk/wp-content/uploads/2018/07/786827-1-eng-GB_squash-and-barley-salad.jpg", difficulty: "medium")

Recipe.find_by(name: "Snap Pea and Green Bean Salad with Arugula Pesto")&.update(cuisine: "Italian", difficulty: "medium")

Recipe.find_by(name: "Skinny Kale Basil Pesto")&.update(cuisine: "Italian", image_url: "https://cdn.loveandlemons.com/wp-content/uploads/2021/01/kale-pesto.jpg", difficulty: "easy")

Recipe.find_by(name: "Greek-Style Baked Fish: Fresh, Simple, and Delicious")&.update(cuisine: "Mediterranean", image_url: "https://themacphersondiaries.co.nz/wp-content/uploads/2022/10/IMG_3692-1024x819.jpg", difficulty: "easy")

Recipe.find_by(name: "Spinach Salad with Strawberry Vinaigrette")&.update(cuisine: "American", image_url: "https://www.allrecipes.com/thmb/hI5hYn1sJB2mJar0h0lechfe1PU=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/AR-14276-Strawberry-Spinach-Salad-4x3-135a121dc0b24ad693289e221dcd3477.jpg", difficulty: "medium")

Recipe.find_by(name: "Salmon with roasted vegetables")&.update(cuisine: "Mediterranean", image_url: "https://www.watchwhatueat.com/wp-content/uploads/2018/08/Baked-Salmon-and-Vegetables-5.jpg", difficulty: "easy")

Recipe.find_by(name: "Cod with Tomato-Olive-Chorizo Sauce and Mashed Potatoes")&.update(cuisine: "Spanish", image_url: "https://images.immediate.co.uk/production/volatile/sites/30/2020/08/cod-chorizo-stew-3c283a6.jpg", difficulty: "medium")

Recipe.find_by(name: "Vegetable Dip")&.update(cuisine: "British", image_url: "https://www.simplyrecipes.com/thmb/pKmb5F1TUFNhkmaRcxEk-INNTcs=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Simply-Recipes-Veggie-Dip-LEAD-01-433c7a3a679b465d9418ad20dd322a3d.jpg", difficulty: "easy")

Recipe.find_by(name: "Balsamic & Honey Glazed Salmon with Lemony Asparagus")&.update(cuisine: "Mediterranean", image_url: "https://therealfooddietitians.com/wp-content/uploads/2023/05/Sheet-Pan-Honey-Glazed-Salmon-7.jpg", difficulty: "medium")

Recipe.find_by(name: "Curried Butternut Squash and Apple Soup")&.update(cuisine: "Indian", image_url: "https://www.aheadofthyme.com/wp-content/uploads/2020/10/butternut-squash-apple-soup.jpg", difficulty: "medium")

puts "Created #{Recipe.count} recipes, #{Ingredient.count} ingredients and #{RecipeIngredient.count} recipe ingredients."
