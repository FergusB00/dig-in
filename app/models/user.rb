class User < ApplicationRecord
  has_many :meals, dependent: :destroy
  has_many :recipes, through: :meals
  has_many :user_ingredients, dependent: :destroy
  has_many :ingredients, through: :user_ingredients
  has_many :questions, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
