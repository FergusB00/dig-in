class UsersController < ApplicationController
  def profile
    @user = current_user
    @ingredients = current_user.user_ingredients.includes(:ingredient)
  end
end
