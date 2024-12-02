class UsersController < ApplicationController
  def profile
    @user = current_user
    @recipes = current_user.recipes
    @ingredients = current_user.user_ingredients.includes(:ingredient).order(created_at: :desc)
    @user_ingredient = UserIngredient.new
    @meals = current_user.meals
    @total_carbon = @meals.map { |meal| meal.carbon_saving }.sum / 1000
    @total_saving = @meals.map { |meal| meal.cost_saving }.sum / 100
  end
end
