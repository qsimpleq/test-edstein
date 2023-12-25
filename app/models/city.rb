class City < ApplicationRecord
  has_one :city_current_weather, dependent: :destroy
  has_one :city_weather_stat, dependent: :destroy
  has_many :city_weathers, dependent: :destroy

  validates :name, presence: true, length: { minimum: 1 }
end
