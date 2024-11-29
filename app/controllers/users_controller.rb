class UsersController < ApplicationController
  def profile
    @user = current_user
    @recipes = current_user.recipes
    @ingredients = current_user.user_ingredients.includes(:ingredient)
    @user_ingredient = UserIngredient.new
    @meals = current_user.meals
    @total_carbon = @meals.map { |meal| meal.carbon_saving }.sum
    @total_saving = @meals.map { |meal| meal.cost_saving }.sum
  end
end
