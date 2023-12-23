class CreateCityWeathers < ActiveRecord::Migration[7.1]
  def change
    create_table :city_weathers do |t|
      t.references :city, null: false, foreign_key: true
      t.timestamp :timestamp
      t.float :temperature

      t.timestamps
    end
  end
end
