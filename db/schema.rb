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

ActiveRecord::Schema[7.1].define(version: 2026_01_24_191219) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "applications", force: :cascade do |t|
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.date "date_of_birth"
    t.string "ssn"
    t.string "phone"
    t.string "email"
    t.string "residence_1_street"
    t.string "residence_1_city"
    t.string "residence_1_state"
    t.string "residence_1_zip"
    t.string "residence_2_street"
    t.string "residence_2_city"
    t.string "residence_2_state"
    t.string "residence_2_zip"
    t.string "residence_3_street"
    t.string "residence_3_city"
    t.string "residence_3_state"
    t.string "residence_3_zip"
    t.string "license_state"
    t.string "license_number"
    t.string "license_type"
    t.date "license_expiration_date"
    t.date "conviction_1_date"
    t.string "conviction_1_violation"
    t.string "conviction_1_state"
    t.string "conviction_1_penalty"
    t.date "conviction_2_date"
    t.string "conviction_2_violation"
    t.string "conviction_2_state"
    t.string "conviction_2_penalty"
    t.date "conviction_3_date"
    t.string "conviction_3_violation"
    t.string "conviction_3_state"
    t.string "conviction_3_penalty"
    t.date "accident_1_date"
    t.string "accident_1_nature"
    t.integer "accident_1_fatalities"
    t.integer "accident_1_injuries"
    t.boolean "accident_1_chemical_spill"
    t.date "accident_2_date"
    t.string "accident_2_nature"
    t.integer "accident_2_fatalities"
    t.integer "accident_2_injuries"
    t.boolean "accident_2_chemical_spill"
    t.date "accident_3_date"
    t.string "accident_3_nature"
    t.integer "accident_3_fatalities"
    t.integer "accident_3_injuries"
    t.boolean "accident_3_chemical_spill"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "residence_1_duration"
    t.string "residence_2_duration"
    t.string "residence_3_duration"
    t.string "straight_truck_type"
    t.date "straight_truck_from"
    t.date "straight_truck_to"
    t.integer "straight_truck_miles"
    t.string "tractor_semi_type"
    t.date "tractor_semi_from"
    t.date "tractor_semi_to"
    t.integer "tractor_semi_miles"
    t.string "tractor_two_trailers_type"
    t.date "tractor_two_trailers_from"
    t.date "tractor_two_trailers_to"
    t.integer "tractor_two_trailers_miles"
    t.string "other_equipment_type"
    t.date "other_equipment_from"
    t.date "other_equipment_to"
    t.integer "other_equipment_miles"
    t.boolean "currently_disqualified"
    t.boolean "license_suspended"
    t.boolean "license_denied"
    t.boolean "positive_drug_test_last_2_years"
    t.boolean "bac_over_point04"
    t.boolean "dui"
    t.boolean "refused_testing"
    t.boolean "controlled_substance_violation"
    t.boolean "drug_transport_possession"
    t.boolean "left_scene_of_accident"
    t.string "employer_1_name"
    t.string "employer_1_street"
    t.string "employer_1_city"
    t.string "employer_1_state"
    t.string "employer_1_zip"
    t.string "employer_1_phone"
    t.string "employer_1_position"
    t.string "employer_1_salary"
    t.date "employer_1_from"
    t.date "employer_1_to"
    t.string "employer_1_reason_for_leaving"
    t.boolean "employer_1_subject_to_fmcsa"
    t.boolean "employer_1_safety_sensitive"
    t.string "employer_2_name"
    t.string "employer_2_street"
    t.string "employer_2_city"
    t.string "employer_2_state"
    t.string "employer_2_zip"
    t.string "employer_2_phone"
    t.string "employer_2_position"
    t.string "employer_2_salary"
    t.date "employer_2_from"
    t.date "employer_2_to"
    t.string "employer_2_reason_for_leaving"
    t.boolean "employer_2_subject_to_fmcsa"
    t.boolean "employer_2_safety_sensitive"
    t.string "employer_3_name"
    t.string "employer_3_street"
    t.string "employer_3_city"
    t.string "employer_3_state"
    t.string "employer_3_zip"
    t.string "employer_3_phone"
    t.string "employer_3_position"
    t.string "employer_3_salary"
    t.date "employer_3_from"
    t.date "employer_3_to"
    t.string "employer_3_reason_for_leaving"
    t.boolean "employer_3_subject_to_fmcsa"
    t.boolean "employer_3_safety_sensitive"
    t.date "gap_1_from"
    t.date "gap_1_to"
    t.string "gap_1_reason"
    t.date "gap_2_from"
    t.date "gap_2_to"
    t.string "gap_2_reason"
    t.date "gap_3_from"
    t.date "gap_3_to"
    t.string "gap_3_reason"
    t.boolean "esign_consent"
    t.datetime "esign_consent_at"
    t.text "esign_consent_text"
    t.string "signature_full_name"
    t.string "signature_method"
    t.datetime "signature_timestamp"
    t.string "signing_ip_address"
    t.string "signing_user_agent"
    t.string "template_version"
    t.string "template_hash"
    t.string "render_engine_version"
    t.datetime "submitted_at"
    t.string "pdf_version"
  end

  create_table "bids", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_images_on_event_id"
  end

  create_table "inquiries", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.string "email_address"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "contacted"
  end

  create_table "ports", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pricing_matrices", force: :cascade do |t|
    t.integer "start_miles"
    t.integer "end_miles"
    t.decimal "line_haul", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "line_haul_plus_29_5_fuel_surcharge", precision: 10, scale: 2
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
    t.boolean "contacted"
    t.string "destination"
    t.float "rate_per_mile"
    t.float "fsch_percent"
    t.float "miles"
    t.float "line_haul"
    t.float "fuel_surcharge"
    t.float "total"
    t.boolean "created_by_employee", default: false, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "role", default: "user"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone_number"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "images", "events"
end
