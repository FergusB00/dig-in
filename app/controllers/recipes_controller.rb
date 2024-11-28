class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show]

  def index
    if params[:query].present?
      p "Query is present"
      @recipes = Recipe.search_by_name_and_cuisine(params[:query])
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

    # if params[:query].present?
    #   @recipes.search_by_filter(params[:query])
    # end


  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:name, :cuisine, :cook_time, :difficulty)
  end
end
