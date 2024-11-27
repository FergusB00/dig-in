class UsersController < ApplicationController
  def profile
    @user = current_user
    @recipes = current_user.recipes
    @ingredients = current_user.user_ingredients.includes(:ingredient)
    @user_ingredient = UserIngredient.new
  end
end
