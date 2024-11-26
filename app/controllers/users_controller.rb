class UsersController < ApplicationController
  def profile
    @user = current_user
    @ingredient = Ingredient.new
    @recipes = current_user.recipes
    @ingredients = current_user.user_ingredients.includes(:ingredient)
  end
end
