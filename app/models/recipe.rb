class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  has_many :meals
  has_many :users, through: :meals

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
end
