class UserIngredient < ApplicationRecord
  belongs_to :user
  belongs_to :ingredient

  validates :quantity, presence: true
  validates :unit, presence: true, inclusion: { in: %w[g kg ml l] }
  validates :weight_in_grams, presence: true
  validates :price_in_pence, presence: true
end
