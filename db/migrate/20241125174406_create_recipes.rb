class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :name
      t.text :instructions
      t.string :cuisine
      t.string :image_url
      t.string :cook_time
      t.string :difficulty

      t.timestamps
    end
  end
end
