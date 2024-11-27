class IngredientsController < ApplicationController
  def create
    @ingredient = Ingredient.find(params[:ingredient_id])
    @new_user_ingredient = user_ingredient.new(new_user_ingredient_params)
  end

  private

  def new_user_ingredient_params
    params.require(:user_ingredients).permit(:quantity, :unit, :price, :expiry) #ingredient name?
  end
end
