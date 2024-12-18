class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  has_many :meals
  has_many :users, through: :meals
  has_neighbors :embedding
  after_create :set_embedding

  scope :order_by_user_expiry_date, ->(user_id) {
    joins(ingredients: :user_ingredients)
      .where(user_ingredients: { user_id: user_id })
      .group('recipes.id')
      .order('MIN(user_ingredients.expiry_date) ASC')
  }

  include PgSearch::Model
  pg_search_scope :search_by_name_and_cuisine_and_difficulty,
                  against: [:name, :cuisine, :difficulty],
                  using: {
                    tsearch: { prefix: true }
                  }

  private

  def set_embedding
    client = OpenAI::Client.new
    response = client.embeddings(
      parameters: {
        model: 'text-embedding-3-small',
        input: "Recipe: #{name}. Instructions: #{instructions}. Cuisine: #{cuisine}. Servings: #{servings}. Cooktime: #{cook_time}"
      }
    )
    self.embedding = response['data'][0]['embedding']
    save
  end
end
