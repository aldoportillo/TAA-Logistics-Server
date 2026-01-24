class RefactorApplicationsForV1Contract < ActiveRecord::Migration[7.1]
  def change
    rename_column :applications, :middle_initial, :middle_name
    rename_column :applications, :address, :street
    rename_column :applications, :birthday, :date_of_birth
    rename_column :applications, :phone_number, :phone

    rename_column :applications, :residency_address_1, :residence_1_street
    rename_column :applications, :residency_city_1, :residence_1_city
    rename_column :applications, :residency_state_1, :residence_1_state
    rename_column :applications, :residency_zip_1, :residence_1_zip

    rename_column :applications, :residency_address_2, :residence_2_street
    rename_column :applications, :residency_city_2, :residence_2_city
    rename_column :applications, :residency_state_2, :residence_2_state
    rename_column :applications, :residency_zip_2, :residence_2_zip

    rename_column :applications, :residency_address_3, :residence_3_street
    rename_column :applications, :residency_city_3, :residence_3_city
    rename_column :applications, :residency_state_3, :residence_3_state
    rename_column :applications, :residency_zip_3, :residence_3_zip

    rename_column :applications, :license_state, :license_1_state
    rename_column :applications, :license_number, :license_1_number
    rename_column :applications, :license_type, :license_1_type
    rename_column :applications, :license_expiration_date, :license_1_expiration

    rename_column :applications, :conviction_date_1, :conviction_1_date
    rename_column :applications, :conviction_violation_1, :conviction_1_violation
    rename_column :applications, :conviction_state_1, :conviction_1_state
    rename_column :applications, :conviction_penalty_1, :conviction_1_penalty

    rename_column :applications, :conviction_date_2, :conviction_2_date
    rename_column :applications, :conviction_violation_2, :conviction_2_violation
    rename_column :applications, :conviction_state_2, :conviction_2_state
    rename_column :applications, :conviction_penalty_2, :conviction_2_penalty

    rename_column :applications, :conviction_date_3, :conviction_3_date
    rename_column :applications, :conviction_violation_3, :conviction_3_violation
    rename_column :applications, :conviction_state_3, :conviction_3_state
    rename_column :applications, :conviction_penalty_3, :conviction_3_penalty

    rename_column :applications, :accident_date_1, :accident_1_date
    rename_column :applications, :accident_nature_1, :accident_1_nature
    rename_column :applications, :accident_fatalities_1, :accident_1_fatalities
    rename_column :applications, :accident_injuries_1, :accident_1_injuries
    rename_column :applications, :accident_spill_1, :accident_1_chemical_spill

    rename_column :applications, :accident_date_2, :accident_2_date
    rename_column :applications, :accident_nature_2, :accident_2_nature
    rename_column :applications, :accident_fatalities_2, :accident_2_fatalities
    rename_column :applications, :accident_injuries_2, :accident_2_injuries
    rename_column :applications, :accident_spill_2, :accident_2_chemical_spill

    rename_column :applications, :accident_date_3, :accident_3_date
    rename_column :applications, :accident_nature_3, :accident_3_nature
    rename_column :applications, :accident_fatalities_3, :accident_3_fatalities
    rename_column :applications, :accident_injuries_3, :accident_3_injuries
    rename_column :applications, :accident_spill_3, :accident_3_chemical_spill

    remove_column :applications, :experience_class_1, :string
    remove_column :applications, :experience_type_1, :string
    remove_column :applications, :experience_start_date_1, :date
    remove_column :applications, :experience_end_date_1, :date
    remove_column :applications, :experience_miles_1, :integer

    remove_column :applications, :experience_class_2, :string
    remove_column :applications, :experience_type_2, :string
    remove_column :applications, :experience_start_date_2, :date
    remove_column :applications, :experience_end_date_2, :date
    remove_column :applications, :experience_miles_2, :integer

    remove_column :applications, :experience_class_3, :string
    remove_column :applications, :experience_type_3, :string
    remove_column :applications, :experience_start_date_3, :date
    remove_column :applications, :experience_end_date_3, :date
    remove_column :applications, :experience_miles_3, :integer

    remove_column :applications, :contacted, :boolean

    add_column :applications, :residence_1_duration, :string
    add_column :applications, :residence_2_duration, :string
    add_column :applications, :residence_3_duration, :string

    add_column :applications, :license_2_state, :string
    add_column :applications, :license_2_number, :string
    add_column :applications, :license_2_type, :string
    add_column :applications, :license_2_expiration, :date

    add_column :applications, :license_3_state, :string
    add_column :applications, :license_3_number, :string
    add_column :applications, :license_3_type, :string
    add_column :applications, :license_3_expiration, :date

    add_column :applications, :conviction_4_date, :date
    add_column :applications, :conviction_4_violation, :string
    add_column :applications, :conviction_4_state, :string
    add_column :applications, :conviction_4_penalty, :string

    add_column :applications, :conviction_5_date, :date
    add_column :applications, :conviction_5_violation, :string
    add_column :applications, :conviction_5_state, :string
    add_column :applications, :conviction_5_penalty, :string

    add_column :applications, :straight_truck_from, :date
    add_column :applications, :straight_truck_to, :date
    add_column :applications, :straight_truck_miles, :integer

    add_column :applications, :tractor_semi_from, :date
    add_column :applications, :tractor_semi_to, :date
    add_column :applications, :tractor_semi_miles, :integer

    add_column :applications, :tractor_two_trailers_from, :date
    add_column :applications, :tractor_two_trailers_to, :date
    add_column :applications, :tractor_two_trailers_miles, :integer

    add_column :applications, :other_equipment_description, :string
    add_column :applications, :other_equipment_from, :date
    add_column :applications, :other_equipment_to, :date
    add_column :applications, :other_equipment_miles, :integer

    add_column :applications, :currently_disqualified, :boolean
    add_column :applications, :license_suspended, :boolean
    add_column :applications, :license_denied, :boolean
    add_column :applications, :positive_drug_test_last_2_years, :boolean
    add_column :applications, :bac_over_point04, :boolean
    add_column :applications, :dui, :boolean
    add_column :applications, :refused_testing, :boolean
    add_column :applications, :controlled_substance_violation, :boolean
    add_column :applications, :drug_transport_possession, :boolean
    add_column :applications, :left_scene_of_accident, :boolean

    add_column :applications, :employer_1_name, :string
    add_column :applications, :employer_1_street, :string
    add_column :applications, :employer_1_city, :string
    add_column :applications, :employer_1_state, :string
    add_column :applications, :employer_1_zip, :string
    add_column :applications, :employer_1_phone, :string
    add_column :applications, :employer_1_position, :string
    add_column :applications, :employer_1_salary, :string
    add_column :applications, :employer_1_from, :date
    add_column :applications, :employer_1_to, :date
    add_column :applications, :employer_1_reason_for_leaving, :string
    add_column :applications, :employer_1_subject_to_fmcsa, :boolean
    add_column :applications, :employer_1_safety_sensitive, :boolean

    add_column :applications, :employer_2_name, :string
    add_column :applications, :employer_2_street, :string
    add_column :applications, :employer_2_city, :string
    add_column :applications, :employer_2_state, :string
    add_column :applications, :employer_2_zip, :string
    add_column :applications, :employer_2_phone, :string
    add_column :applications, :employer_2_position, :string
    add_column :applications, :employer_2_salary, :string
    add_column :applications, :employer_2_from, :date
    add_column :applications, :employer_2_to, :date
    add_column :applications, :employer_2_reason_for_leaving, :string
    add_column :applications, :employer_2_subject_to_fmcsa, :boolean
    add_column :applications, :employer_2_safety_sensitive, :boolean

    add_column :applications, :employer_3_name, :string
    add_column :applications, :employer_3_street, :string
    add_column :applications, :employer_3_city, :string
    add_column :applications, :employer_3_state, :string
    add_column :applications, :employer_3_zip, :string
    add_column :applications, :employer_3_phone, :string
    add_column :applications, :employer_3_position, :string
    add_column :applications, :employer_3_salary, :string
    add_column :applications, :employer_3_from, :date
    add_column :applications, :employer_3_to, :date
    add_column :applications, :employer_3_reason_for_leaving, :string
    add_column :applications, :employer_3_subject_to_fmcsa, :boolean
    add_column :applications, :employer_3_safety_sensitive, :boolean

    add_column :applications, :gap_1_from, :date
    add_column :applications, :gap_1_to, :date
    add_column :applications, :gap_1_reason, :string

    add_column :applications, :gap_2_from, :date
    add_column :applications, :gap_2_to, :date
    add_column :applications, :gap_2_reason, :string

    add_column :applications, :esign_consent, :boolean
    add_column :applications, :esign_consent_at, :datetime
    add_column :applications, :esign_consent_text, :text
    add_column :applications, :signature_full_name, :string
    add_column :applications, :signature_method, :string
    add_column :applications, :signature_timestamp, :datetime
    add_column :applications, :signing_ip_address, :string
    add_column :applications, :signing_user_agent, :string

    add_column :applications, :template_version, :string
    add_column :applications, :template_hash, :string
    add_column :applications, :render_engine_version, :string

    add_column :applications, :submitted_at, :datetime
    add_column :applications, :pdf_version, :string
  end
end
