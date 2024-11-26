class UsersController < ApplicationController
  def profile
    @user = current_user
    @recipes = current_user.recipes
    @ingredients = current_user.user_ingredients.includes(:ingredient)
  end

  def create
    @ingredient = Ingredient.find(params[:ingredient_id])
    @new_user_ingredient = Ingredient.new(new_user_ingredient_params)
  end

  private

  def new_user_ingredient_params
    params.require(:user_ingredients).permit(:quantity, :unit, :price, :expiry) #ingredient name?
  end
end
