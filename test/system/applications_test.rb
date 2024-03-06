require "application_system_test_case"

class ApplicationsTest < ApplicationSystemTestCase
  setup do
    @application = applications(:one)
  end

  test "visiting the index" do
    visit applications_url
    assert_selector "h1", text: "Applications"
  end

  test "should create application" do
    visit applications_url
    click_on "New application"

    fill_in "Accident date 1", with: @application.accident_date_1
    fill_in "Accident date 2", with: @application.accident_date_2
    fill_in "Accident date 3", with: @application.accident_date_3
    fill_in "Accident fatalities 1", with: @application.accident_fatalities_1
    fill_in "Accident fatalities 2", with: @application.accident_fatalities_2
    fill_in "Accident fatalities 3", with: @application.accident_fatalities_3
    fill_in "Accident injuries 1", with: @application.accident_injuries_1
    fill_in "Accident injuries 2", with: @application.accident_injuries_2
    fill_in "Accident injuries 3", with: @application.accident_injuries_3
    fill_in "Accident nature 1", with: @application.accident_nature_1
    fill_in "Accident nature 2", with: @application.accident_nature_2
    fill_in "Accident nature 3", with: @application.accident_nature_3
    check "Accident spill 1" if @application.accident_spill_1
    check "Accident spill 2" if @application.accident_spill_2
    check "Accident spill 3" if @application.accident_spill_3
    fill_in "Address", with: @application.address
    fill_in "Birthday", with: @application.birthday
    fill_in "City", with: @application.city
    fill_in "Conviction date 1", with: @application.conviction_date_1
    fill_in "Conviction date 2", with: @application.conviction_date_2
    fill_in "Conviction date 3", with: @application.conviction_date_3
    fill_in "Conviction penalty 1", with: @application.conviction_penalty_1
    fill_in "Conviction penalty 2", with: @application.conviction_penalty_2
    fill_in "Conviction penalty 3", with: @application.conviction_penalty_3
    fill_in "Conviction state 1", with: @application.conviction_state_1
    fill_in "Conviction state 2", with: @application.conviction_state_2
    fill_in "Conviction state 3", with: @application.conviction_state_3
    fill_in "Conviction violation 1", with: @application.conviction_violation_1
    fill_in "Conviction violation 2", with: @application.conviction_violation_2
    fill_in "Conviction violation 3", with: @application.conviction_violation_3
    fill_in "Email", with: @application.email
    fill_in "Experience class 1", with: @application.experience_class_1
    fill_in "Experience class 2", with: @application.experience_class_2
    fill_in "Experience class 3", with: @application.experience_class_3
    fill_in "Experience end date 1", with: @application.experience_end_date_1
    fill_in "Experience end date 2", with: @application.experience_end_date_2
    fill_in "Experience end date 3", with: @application.experience_end_date_3
    fill_in "Experience miles 1", with: @application.experience_miles_1
    fill_in "Experience miles 2", with: @application.experience_miles_2
    fill_in "Experience miles 3", with: @application.experience_miles_3
    fill_in "Experience start date 1", with: @application.experience_start_date_1
    fill_in "Experience start date 2", with: @application.experience_start_date_2
    fill_in "Experience start date 3", with: @application.experience_start_date_3
    fill_in "Experience type 1", with: @application.experience_type_1
    fill_in "Experience type 2", with: @application.experience_type_2
    fill_in "Experience type 3", with: @application.experience_type_3
    fill_in "First name", with: @application.first_name
    fill_in "Last name", with: @application.last_name
    fill_in "License expiration date", with: @application.license_expiration_date
    fill_in "License number", with: @application.license_number
    fill_in "License state", with: @application.license_state
    fill_in "License type", with: @application.license_type
    fill_in "Middle initial", with: @application.middle_initial
    fill_in "Phone number", with: @application.phone_number
    fill_in "Residency address 1", with: @application.residency_address_1
    fill_in "Residency address 2", with: @application.residency_address_2
    fill_in "Residency address 3", with: @application.residency_address_3
    fill_in "Residency city 1", with: @application.residency_city_1
    fill_in "Residency city 2", with: @application.residency_city_2
    fill_in "Residency city 3", with: @application.residency_city_3
    fill_in "Residency state 1", with: @application.residency_state_1
    fill_in "Residency state 2", with: @application.residency_state_2
    fill_in "Residency state 3", with: @application.residency_state_3
    fill_in "Residency zip 1", with: @application.residency_zip_1
    fill_in "Residency zip 2", with: @application.residency_zip_2
    fill_in "Residency zip 3", with: @application.residency_zip_3
    fill_in "Ssn", with: @application.ssn
    fill_in "State", with: @application.state
    fill_in "Zip", with: @application.zip
    click_on "Create Application"

    assert_text "Application was successfully created"
    click_on "Back"
  end

  test "should update Application" do
    visit application_url(@application)
    click_on "Edit this application", match: :first

    fill_in "Accident date 1", with: @application.accident_date_1
    fill_in "Accident date 2", with: @application.accident_date_2
    fill_in "Accident date 3", with: @application.accident_date_3
    fill_in "Accident fatalities 1", with: @application.accident_fatalities_1
    fill_in "Accident fatalities 2", with: @application.accident_fatalities_2
    fill_in "Accident fatalities 3", with: @application.accident_fatalities_3
    fill_in "Accident injuries 1", with: @application.accident_injuries_1
    fill_in "Accident injuries 2", with: @application.accident_injuries_2
    fill_in "Accident injuries 3", with: @application.accident_injuries_3
    fill_in "Accident nature 1", with: @application.accident_nature_1
    fill_in "Accident nature 2", with: @application.accident_nature_2
    fill_in "Accident nature 3", with: @application.accident_nature_3
    check "Accident spill 1" if @application.accident_spill_1
    check "Accident spill 2" if @application.accident_spill_2
    check "Accident spill 3" if @application.accident_spill_3
    fill_in "Address", with: @application.address
    fill_in "Birthday", with: @application.birthday
    fill_in "City", with: @application.city
    fill_in "Conviction date 1", with: @application.conviction_date_1
    fill_in "Conviction date 2", with: @application.conviction_date_2
    fill_in "Conviction date 3", with: @application.conviction_date_3
    fill_in "Conviction penalty 1", with: @application.conviction_penalty_1
    fill_in "Conviction penalty 2", with: @application.conviction_penalty_2
    fill_in "Conviction penalty 3", with: @application.conviction_penalty_3
    fill_in "Conviction state 1", with: @application.conviction_state_1
    fill_in "Conviction state 2", with: @application.conviction_state_2
    fill_in "Conviction state 3", with: @application.conviction_state_3
    fill_in "Conviction violation 1", with: @application.conviction_violation_1
    fill_in "Conviction violation 2", with: @application.conviction_violation_2
    fill_in "Conviction violation 3", with: @application.conviction_violation_3
    fill_in "Email", with: @application.email
    fill_in "Experience class 1", with: @application.experience_class_1
    fill_in "Experience class 2", with: @application.experience_class_2
    fill_in "Experience class 3", with: @application.experience_class_3
    fill_in "Experience end date 1", with: @application.experience_end_date_1
    fill_in "Experience end date 2", with: @application.experience_end_date_2
    fill_in "Experience end date 3", with: @application.experience_end_date_3
    fill_in "Experience miles 1", with: @application.experience_miles_1
    fill_in "Experience miles 2", with: @application.experience_miles_2
    fill_in "Experience miles 3", with: @application.experience_miles_3
    fill_in "Experience start date 1", with: @application.experience_start_date_1
    fill_in "Experience start date 2", with: @application.experience_start_date_2
    fill_in "Experience start date 3", with: @application.experience_start_date_3
    fill_in "Experience type 1", with: @application.experience_type_1
    fill_in "Experience type 2", with: @application.experience_type_2
    fill_in "Experience type 3", with: @application.experience_type_3
    fill_in "First name", with: @application.first_name
    fill_in "Last name", with: @application.last_name
    fill_in "License expiration date", with: @application.license_expiration_date
    fill_in "License number", with: @application.license_number
    fill_in "License state", with: @application.license_state
    fill_in "License type", with: @application.license_type
    fill_in "Middle initial", with: @application.middle_initial
    fill_in "Phone number", with: @application.phone_number
    fill_in "Residency address 1", with: @application.residency_address_1
    fill_in "Residency address 2", with: @application.residency_address_2
    fill_in "Residency address 3", with: @application.residency_address_3
    fill_in "Residency city 1", with: @application.residency_city_1
    fill_in "Residency city 2", with: @application.residency_city_2
    fill_in "Residency city 3", with: @application.residency_city_3
    fill_in "Residency state 1", with: @application.residency_state_1
    fill_in "Residency state 2", with: @application.residency_state_2
    fill_in "Residency state 3", with: @application.residency_state_3
    fill_in "Residency zip 1", with: @application.residency_zip_1
    fill_in "Residency zip 2", with: @application.residency_zip_2
    fill_in "Residency zip 3", with: @application.residency_zip_3
    fill_in "Ssn", with: @application.ssn
    fill_in "State", with: @application.state
    fill_in "Zip", with: @application.zip
    click_on "Update Application"

    assert_text "Application was successfully updated"
    click_on "Back"
  end

  test "should destroy Application" do
    visit application_url(@application)
    click_on "Destroy this application", match: :first

    assert_text "Application was successfully destroyed"
  end
end
