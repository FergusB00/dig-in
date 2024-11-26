class UsersController < ApplicationController
  def profile
    @user = current_user
    @ingredient = Ingredient.new
    @recipes = current_user.recipes
  end
end
