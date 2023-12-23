class City < ApplicationRecord
  has_many :city_weathers, dependent: :destroy

  validates :name, presence: true, length: { minimum: 1 }
end
