class MealsController < ApplicationController
  before_action :set_meal, only: [:show]

  def index
    @meals = current_user.meals
  end

  def create
    recipe = Recipe.find(params[:recipe_id])
    carbon_saving = calculate_carbon_savings(recipe)
    cost_saving = calculate_cost_savings(recipe)

    @meal = Meal.create(
      recipe_id: recipe,
      user_id: current_user,
      cooked: true,
      carbon_saving: carbon_saving,
      cost_saving: cost_saving
    )

    redirect_to profile_path
  end

  private

  def set_meal
    @meal = Meal.find(params[:id])
  end

  def calculate_carbon_savings(recipe)
    recipe.recipe_ingredients.sum do |recipeingredient|
      ingredient = recipeingredient.ingredient
      ingredient.carbon_per_gram * recipeingredient.weight_in_grams
    end
  end

  def calculate_cost_savings(recipe)
    recipe.recipe_ingredients.sum do |recipeingredient|
      user_ingredient = current_user.user_ingredients
                                    .where(ingredient: recipeingredient.ingredient)
                                    .where('weight_in_grams >= ?', recipeingredient.weight_in_grams)
                                    .where('expiry_date >= ?', Date.today).order(expiry_date: :desc).first
      if user_ingredient.nil?
        0
      else
        user_ingredient.price_per_gram * recipeingredient.weight_in_grams
      end
    end
  end

  def update_user_ingredients_qty(recipe)
    recipe.recipe_ingredients.each do |recipeingredient|
      user_ingredient = current_user.user_ingredients
                                    .where(ingredient: recipeingredient.ingredient)
                                    .where('weight_in_grams >= ?', recipeingredient.weight_in_grams)
                                    .where('expiry_date >= ?', Date.today).order(expiry_date: :desc).first
      user_ingredient.update(weight_in_grams: user_ingredient.weight_in_grams - recipeingredient.weight_in_grams)
    end
  end
end