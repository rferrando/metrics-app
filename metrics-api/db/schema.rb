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

ActiveRecord::Schema.define(version: 2024_07_13_074808) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aggregated_metrics", force: :cascade do |t|
    t.string "name"
    t.integer "period"
    t.datetime "timestamp"
    t.decimal "average_value", precision: 10, scale: 2
    t.decimal "min_value", precision: 10, scale: 2
    t.decimal "max_value", precision: 10, scale: 2
    t.decimal "total_value", precision: 10, scale: 2
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "period", "timestamp"], name: "index_aggregated_metrics_on_name_and_period_and_timestamp", unique: true
  end

  create_table "aggregation_states", force: :cascade do |t|
    t.string "name"
    t.integer "period"
    t.datetime "last_aggregated_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "period"], name: "index_aggregation_states_on_name_and_period", unique: true
  end

  create_table "metrics", force: :cascade do |t|
    t.string "name"
    t.decimal "value", precision: 10, scale: 2
    t.datetime "timestamp", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "minute_precision"
    t.datetime "hour_precision"
    t.datetime "day_precision"
    t.index ["name", "created_at"], name: "index_metrics_on_name_and_created_at"
    t.index ["name", "day_precision"], name: "index_metrics_on_name_and_day_precision"
    t.index ["name", "hour_precision"], name: "index_metrics_on_name_and_hour_precision"
    t.index ["name", "minute_precision"], name: "index_metrics_on_name_and_minute_precision"
    t.index ["name", "value", "timestamp"], name: "unique_index_metrics_on_name_value_and_timestamp", unique: true
  end

end
