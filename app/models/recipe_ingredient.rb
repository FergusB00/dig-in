class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  after_create :convert_items_to_servings
  after_create :convert_weight_to_grams

  def convert_items_to_servings
    if self.unit == "small" || self.unit == "medium" || self.unit == "large"
      update(unit: "servings")
    end
  end

  def convert_weight_to_grams
    self.weight_in_grams = case unit.downcase
                           when "servings" then quantity * 75
                           when "g", "ml" then quantity
                           when "cloves" then quantity * 10
                           when "tbsps", "tbsp" then quantity * 15
                           when "tsps", "tsp" then quantity * 5
                           when "l", "kg" then quantity * 1000
                           when "dashes" then quantity * 0
                           when "pkt" then quantity * 500
                           when "stalks" then quantity * 40
                           else quantity * 20
                           end
    self.save!
  end
end
