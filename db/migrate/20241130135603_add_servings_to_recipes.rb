class AddServingsToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :servings, :integer
  end
end
