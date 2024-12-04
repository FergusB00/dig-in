class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show]

  def index
    if params[:query].present?
      p "Query is present"
      @recipes = Recipe.search_by_name_and_cuisine_and_difficulty(params[:query])
      p @recipes.count
    else
      @recipes = Recipe.all
    end

    if params[:available_ingredients_only].present?
      p "available only please!"
      user_ingredients = current_user.ingredients #change current_user.ingredients to filter user_ingredients by expiry here if needed
      available_recipe_ids = RecipeIngredient.where(ingredient: user_ingredients).pluck(:recipe_id)

      @recipes = @recipes.where(id: available_recipe_ids)
    end

    if params[:order] == 'expiry_date'
      @recipes = @recipes.order_by_user_expiry_date(current_user.id)
    end

    if params[:order] == 'most_user_ingredients'
      user_ingredient_ids = current_user.ingredients.pluck(:id)

      @recipes = @recipes.joins(:ingredients).group("recipes.id").order("COUNT(ingredients.id) DESC").where(ingredients: { id: user_ingredient_ids })
    end
  end

  def show
    @user_ingredients = current_user.user_ingredients.pluck(:ingredient_id)
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:name, :cuisine, :cook_time, :difficulty)
  end
end
