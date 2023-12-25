class CreateCityWeatherStats < ActiveRecord::Migration[7.1]
  def change
    create_table :city_weather_stats do |t|
      t.references :city, null: false, foreign_key: true
      t.float :avg_temperature, null: false
      t.float :max_temperature, null: false
      t.float :min_temperature, null: false

      t.timestamps
    end
  end
end
