class UserIngredientsController < ApplicationController
  def create
    @user_ingredient = UserIngredient.new(user_ingredient_params)
    @user_ingredient.user = current_user
    if @user_ingredient.save
      redirect_to profile_path, notice: "Ingredient successfully added!"
    else
      p @user_ingredient.errors.messages
      redirect_to profile_path, status: :unprocessable_entity
    end
  end

  private

  def user_ingredient_params
    #check if need to add name to user_ingredients schema
    params.require(:user_ingredient).permit(:ingredient_id, :quantity, :unit, :price_in_pence, :expiry_date)
  end
end
