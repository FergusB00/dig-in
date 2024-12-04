class MealsController < ApplicationController
  # before_action :set_meal, only: [:show]

  def index
    @meals = current_user.meals
  end

  def create
    @recipe = Recipe.find(params[:recipe_id])
    carbon_saving = calculate_carbon_savings(@recipe)
    cost_saving = calculate_cost_savings(@recipe)

    @meal = Meal.new(
      recipe: @recipe,
      user: current_user,
      cooked: true,
      carbon_saving: carbon_saving,
      cost_saving: cost_saving
    )

    if @meal.save
      update_user_ingredients_qty(@recipe)
      redirect_to profile_path, notice: "#{@meal.recipe.name} Added!"
    else
      p @meal.errors.messages
      render "recipes/show", status: :unprocessable_entity
    end
  end

  private

  def set_meal
    @meal = Meal.find(params[:id])
  end

  #carbon for all ingredients in meal, not just user ingredients used in meal
  def calculate_carbon_savings(recipe)
    recipe.recipe_ingredients.sum do |recipeingredient|
      p recipeingredient
      user_ingredient = current_user.user_ingredients
                                    .where(ingredient: recipeingredient.ingredient)
                                    .where('weight_in_grams >= ?', recipeingredient.weight_in_grams)
                                    .where('expiry_date >= ?', Date.today).order(expiry_date: :desc).first
      if user_ingredient.nil?
        0.0
      else
        ingredient = recipeingredient.ingredient
        ingredient.carbon_per_gram.to_f * user_ingredient.weight_in_grams
      end
    end
  end

  def calculate_cost_savings(recipe)
    recipe.recipe_ingredients.sum do |recipeingredient|
      user_ingredient = current_user.user_ingredients
                                    .where(ingredient: recipeingredient.ingredient)
                                    .where('weight_in_grams >= ?', recipeingredient.weight_in_grams)
                                    .where('expiry_date >= ?', Date.today).order(expiry_date: :desc).first
      #add if statement so if attribute is nil then will assign random
      if user_ingredient.nil?
        0
      else
        user_ingredient.price_per_gram * recipeingredient.weight_in_grams
      end
    end
  end

  def update_user_ingredients_qty(recipe)
    p "updating user recipes"
    recipe.recipe_ingredients.each do |recipeingredient|
      user_ingredient = current_user.user_ingredients
                                    .where(ingredient: recipeingredient.ingredient)
                                    .where('weight_in_grams >= ?', recipeingredient.weight_in_grams)
                                    .where('expiry_date >= ?', Date.today).order(expiry_date: :desc).first
      user_ingredient&.update(weight_in_grams: user_ingredient.weight_in_grams - recipeingredient.weight_in_grams)
    end
  end
end
