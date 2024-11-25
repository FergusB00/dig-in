class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :name, null: false
      t.text :instructions, null: false
      t.string :cuisine, null: false
      t.string :image_url, null: false
      t.string :cook_time, null: false
      t.string :difficulty, null: false

      t.timestamps
    end
  end
end
