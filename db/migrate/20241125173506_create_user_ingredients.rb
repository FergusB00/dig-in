class CreateUserIngredients < ActiveRecord::Migration[7.1]
  def change
    create_table :user_ingredients do |t|
      t.integer :quantity
      t.date :expiry_date
      t.integer :price_per_gram
      t.string :unit
      t.integer :weight_in_g
      t.integer :price_in_pence
      t.references :user, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true

      t.timestamps
    end
  end
end
