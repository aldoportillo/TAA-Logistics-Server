class CreateApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications do |t|
      t.string :first_name
      t.string :middle_initial
      t.string :last_name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.date :birthday
      t.string :ssn
      t.string :phone_number
      t.string :email
      t.string :residency_address_1
      t.string :residency_city_1
      t.string :residency_state_1
      t.string :residency_zip_1
      t.string :residency_address_2
      t.string :residency_city_2
      t.string :residency_state_2
      t.string :residency_zip_2
      t.string :residency_address_3
      t.string :residency_city_3
      t.string :residency_state_3
      t.string :residency_zip_3
      t.string :license_state
      t.string :license_number
      t.string :license_type
      t.date :license_expiration_date
      t.date :conviction_date_1
      t.string :conviction_violation_1
      t.string :conviction_state_1
      t.string :conviction_penalty_1
      t.date :conviction_date_2
      t.string :conviction_violation_2
      t.string :conviction_state_2
      t.string :conviction_penalty_2
      t.date :conviction_date_3
      t.string :conviction_violation_3
      t.string :conviction_state_3
      t.string :conviction_penalty_3
      t.string :experience_class_1
      t.string :experience_type_1
      t.date :experience_start_date_1
      t.date :experience_end_date_1
      t.integer :experience_miles_1
      t.string :experience_class_2
      t.string :experience_type_2
      t.date :experience_start_date_2
      t.date :experience_end_date_2
      t.integer :experience_miles_2
      t.string :experience_class_3
      t.string :experience_type_3
      t.date :experience_start_date_3
      t.date :experience_end_date_3
      t.integer :experience_miles_3
      t.date :accident_date_1
      t.string :accident_nature_1
      t.integer :accident_fatalities_1
      t.integer :accident_injuries_1
      t.boolean :accident_spill_1
      t.date :accident_date_2
      t.string :accident_nature_2
      t.integer :accident_fatalities_2
      t.integer :accident_injuries_2
      t.boolean :accident_spill_2
      t.date :accident_date_3
      t.string :accident_nature_3
      t.integer :accident_fatalities_3
      t.integer :accident_injuries_3
      t.boolean :accident_spill_3

      t.timestamps
    end
  end
end
