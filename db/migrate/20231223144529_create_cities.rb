class CreateCities < ActiveRecord::Migration[7.1]
  def change
    create_table :cities do |t|
      t.string :name, null: false
      t.string :location

      t.timestamps
    end
    add_index :cities, :location, unique: true
  end
end
