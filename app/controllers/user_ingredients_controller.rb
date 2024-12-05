class UserIngredientsController < ApplicationController
  def create
    ingredient = Ingredient.find_or_create_by(name: user_ingredient_params[:ingredient_attributes][:name])
    @user_ingredient = UserIngredient.new(
      ingredient: ingredient,
      quantity: user_ingredient_params[:quantity],
      unit: user_ingredient_params[:unit],
      price_in_pounds: user_ingredient_params[:price_in_pounds],
      expiry_date: user_ingredient_params[:expiry_date])
    @user_ingredient.user = current_user
    if @user_ingredient.save
      redirect_to profile_path, notice: "Ingredient successfully added!"
    else
      p @user_ingredient.errors.messages
      redirect_to profile_path, status: :unprocessable_entity
    end
  end

  def destroy
    @user_ingredient = UserIngredient.find(params[:id])
    @user_ingredient.destroy
    redirect_to profile_path, status: :see_other, notice: "#{@user_ingredient.ingredient.name.capitalize} deleted"
  end

  private

  def user_ingredient_params
    params.require(:user_ingredient).permit(:quantity, :unit, :price_in_pounds, :expiry_date, ingredient_attributes: [:name])
  end
end
