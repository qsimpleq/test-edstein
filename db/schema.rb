# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_12_24_124100) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location"], name: "index_cities_on_location", unique: true
  end

  create_table "city_current_weathers", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.datetime "timestamp", precision: nil
    t.float "temperature"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_city_current_weathers_on_city_id"
  end

  create_table "city_weather_currents", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.datetime "timestamp", precision: nil, null: false
    t.float "temperature", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_city_weather_currents_on_city_id"
  end

  create_table "city_weather_stats", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.float "avg_temperature", null: false
    t.float "max_temperature", null: false
    t.float "min_temperature", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_city_weather_stats_on_city_id"
  end

  create_table "city_weathers", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.datetime "timestamp", precision: nil
    t.float "temperature"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_city_weathers_on_city_id"
  end

  create_table "create_weather_data", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.datetime "timestamp", precision: nil, null: false
    t.float "temperature", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_create_weather_data_on_city_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  add_foreign_key "city_current_weathers", "cities"
  add_foreign_key "city_weather_currents", "cities"
  add_foreign_key "city_weather_stats", "cities"
  add_foreign_key "city_weathers", "cities"
  add_foreign_key "create_weather_data", "cities"
end
