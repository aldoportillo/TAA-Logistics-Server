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

ActiveRecord::Schema[7.1].define(version: 2024_03_06_202405) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "applications", force: :cascade do |t|
    t.string "first_name"
    t.string "middle_initial"
    t.string "last_name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.date "birthday"
    t.string "ssn"
    t.string "phone_number"
    t.string "email"
    t.string "residency_address_1"
    t.string "residency_city_1"
    t.string "residency_state_1"
    t.string "residency_zip_1"
    t.string "residency_address_2"
    t.string "residency_city_2"
    t.string "residency_state_2"
    t.string "residency_zip_2"
    t.string "residency_address_3"
    t.string "residency_city_3"
    t.string "residency_state_3"
    t.string "residency_zip_3"
    t.string "license_state"
    t.string "license_number"
    t.string "license_type"
    t.date "license_expiration_date"
    t.date "conviction_date_1"
    t.string "conviction_violation_1"
    t.string "conviction_state_1"
    t.string "conviction_penalty_1"
    t.date "conviction_date_2"
    t.string "conviction_violation_2"
    t.string "conviction_state_2"
    t.string "conviction_penalty_2"
    t.date "conviction_date_3"
    t.string "conviction_violation_3"
    t.string "conviction_state_3"
    t.string "conviction_penalty_3"
    t.string "experience_class_1"
    t.string "experience_type_1"
    t.date "experience_start_date_1"
    t.date "experience_end_date_1"
    t.integer "experience_miles_1"
    t.string "experience_class_2"
    t.string "experience_type_2"
    t.date "experience_start_date_2"
    t.date "experience_end_date_2"
    t.integer "experience_miles_2"
    t.string "experience_class_3"
    t.string "experience_type_3"
    t.date "experience_start_date_3"
    t.date "experience_end_date_3"
    t.integer "experience_miles_3"
    t.date "accident_date_1"
    t.string "accident_nature_1"
    t.integer "accident_fatalities_1"
    t.integer "accident_injuries_1"
    t.boolean "accident_spill_1"
    t.date "accident_date_2"
    t.string "accident_nature_2"
    t.integer "accident_fatalities_2"
    t.integer "accident_injuries_2"
    t.boolean "accident_spill_2"
    t.date "accident_date_3"
    t.string "accident_nature_3"
    t.integer "accident_fatalities_3"
    t.integer "accident_injuries_3"
    t.boolean "accident_spill_3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quotes", force: :cascade do |t|
    t.string "company_name"
    t.string "contact_name"
    t.string "email"
    t.string "phone"
    t.string "fax"
    t.string "commodity"
    t.integer "commodity_temp"
    t.integer "commodity_gross_weight"
    t.string "from"
    t.date "delivery_date"
    t.string "delivery_zip_code"
    t.date "shipping_date"
    t.string "shipping_zip_code"
    t.integer "CS"
    t.string "container_size"
    t.integer "pallets"
    t.string "equipment_type"
    t.string "rail_destination"
    t.string "questions_or_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.boolean "admin"
    t.date "birthday"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
