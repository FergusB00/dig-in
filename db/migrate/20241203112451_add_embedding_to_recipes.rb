class AddEmbeddingToRecipes < ActiveRecord::Migration[7.2]
  def change
    add_column :recipes, :embedding, :vector, limit: 1536
  end
end
