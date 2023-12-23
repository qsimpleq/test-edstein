class CreateCities < ActiveRecord::Migration[7.1]
  def change
    create_table :cities do |t|
      t.string :name, null: false
      t.string :location_key

      t.timestamps
    end
    add_index :cities, :location_key, unique: true
  end
end
