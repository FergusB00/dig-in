class AddPriceInPoundsToUserIngredients < ActiveRecord::Migration[7.1]
  def change
    add_column :user_ingredients, :price_in_pounds, :float
  end
end
