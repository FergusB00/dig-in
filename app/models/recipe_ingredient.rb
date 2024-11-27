class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  after_create :convert_items_to_servings
  # after_create :convert_weight_to_grams

  def convert_items_to_servings
    if self.unit == "small" || self.unit == "medium" || self.unit == "large"
      update(unit: "servings")
    end
  end

  # def convert_weight_to_grams

  # end

end
