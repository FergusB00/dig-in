class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  has_many :meals
  has_many :users, through: :meals

  include PgSearch::Model
  pg_search_scope :search_by_name_and_cuisine_and_difficulty,
                  against: [:name, :cuisine, :difficulty],
                  using: {
                    tsearch: { prefix: true }
                  }
end
