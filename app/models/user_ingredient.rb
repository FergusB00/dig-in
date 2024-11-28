class UserIngredient < ApplicationRecord
  belongs_to :user
  belongs_to :ingredient

  validates :quantity, presence: true
  validates :unit, presence: true, inclusion: { in: %w[g kg ml l] }
  validates :price_in_pence, presence: true

  after_create :convert_weight_to_grams

  def convert_weight_to_grams
    self.weight_in_grams = case unit.downcase
                           when "servings" then quantity * 75
                           when "g", "ml" then quantity
                           when "cloves" then quantity * 10
                           when "tbsps" then quantity * 15
                           when "tsps" then quantity * 5
                           when "l", "kg" then quantity * 1000
                           when "dashes" then quantity * 0
                           else quantity * 20
                           end
    self.save!
  end
end
