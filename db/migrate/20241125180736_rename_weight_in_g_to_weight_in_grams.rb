class RenameWeightInGToWeightInGrams < ActiveRecord::Migration[7.1]
  def change
    rename_column :user_ingredients, :weight_in_g, :weight_in_grams
  end
end
