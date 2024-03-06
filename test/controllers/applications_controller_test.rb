require "test_helper"

class ApplicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @application = applications(:one)
  end

  test "should get index" do
    get applications_url
    assert_response :success
  end

  test "should get new" do
    get new_application_url
    assert_response :success
  end

  test "should create application" do
    assert_difference("Application.count") do
      post applications_url, params: { application: { accident_date_1: @application.accident_date_1, accident_date_2: @application.accident_date_2, accident_date_3: @application.accident_date_3, accident_fatalities_1: @application.accident_fatalities_1, accident_fatalities_2: @application.accident_fatalities_2, accident_fatalities_3: @application.accident_fatalities_3, accident_injuries_1: @application.accident_injuries_1, accident_injuries_2: @application.accident_injuries_2, accident_injuries_3: @application.accident_injuries_3, accident_nature_1: @application.accident_nature_1, accident_nature_2: @application.accident_nature_2, accident_nature_3: @application.accident_nature_3, accident_spill_1: @application.accident_spill_1, accident_spill_2: @application.accident_spill_2, accident_spill_3: @application.accident_spill_3, address: @application.address, birthday: @application.birthday, city: @application.city, conviction_date_1: @application.conviction_date_1, conviction_date_2: @application.conviction_date_2, conviction_date_3: @application.conviction_date_3, conviction_penalty_1: @application.conviction_penalty_1, conviction_penalty_2: @application.conviction_penalty_2, conviction_penalty_3: @application.conviction_penalty_3, conviction_state_1: @application.conviction_state_1, conviction_state_2: @application.conviction_state_2, conviction_state_3: @application.conviction_state_3, conviction_violation_1: @application.conviction_violation_1, conviction_violation_2: @application.conviction_violation_2, conviction_violation_3: @application.conviction_violation_3, email: @application.email, experience_class_1: @application.experience_class_1, experience_class_2: @application.experience_class_2, experience_class_3: @application.experience_class_3, experience_end_date_1: @application.experience_end_date_1, experience_end_date_2: @application.experience_end_date_2, experience_end_date_3: @application.experience_end_date_3, experience_miles_1: @application.experience_miles_1, experience_miles_2: @application.experience_miles_2, experience_miles_3: @application.experience_miles_3, experience_start_date_1: @application.experience_start_date_1, experience_start_date_2: @application.experience_start_date_2, experience_start_date_3: @application.experience_start_date_3, experience_type_1: @application.experience_type_1, experience_type_2: @application.experience_type_2, experience_type_3: @application.experience_type_3, first_name: @application.first_name, last_name: @application.last_name, license_expiration_date: @application.license_expiration_date, license_number: @application.license_number, license_state: @application.license_state, license_type: @application.license_type, middle_initial: @application.middle_initial, phone_number: @application.phone_number, residency_address_1: @application.residency_address_1, residency_address_2: @application.residency_address_2, residency_address_3: @application.residency_address_3, residency_city_1: @application.residency_city_1, residency_city_2: @application.residency_city_2, residency_city_3: @application.residency_city_3, residency_state_1: @application.residency_state_1, residency_state_2: @application.residency_state_2, residency_state_3: @application.residency_state_3, residency_zip_1: @application.residency_zip_1, residency_zip_2: @application.residency_zip_2, residency_zip_3: @application.residency_zip_3, ssn: @application.ssn, state: @application.state, zip: @application.zip } }
    end

    assert_redirected_to application_url(Application.last)
  end

  test "should show application" do
    get application_url(@application)
    assert_response :success
  end

  test "should get edit" do
    get edit_application_url(@application)
    assert_response :success
  end

  test "should update application" do
    patch application_url(@application), params: { application: { accident_date_1: @application.accident_date_1, accident_date_2: @application.accident_date_2, accident_date_3: @application.accident_date_3, accident_fatalities_1: @application.accident_fatalities_1, accident_fatalities_2: @application.accident_fatalities_2, accident_fatalities_3: @application.accident_fatalities_3, accident_injuries_1: @application.accident_injuries_1, accident_injuries_2: @application.accident_injuries_2, accident_injuries_3: @application.accident_injuries_3, accident_nature_1: @application.accident_nature_1, accident_nature_2: @application.accident_nature_2, accident_nature_3: @application.accident_nature_3, accident_spill_1: @application.accident_spill_1, accident_spill_2: @application.accident_spill_2, accident_spill_3: @application.accident_spill_3, address: @application.address, birthday: @application.birthday, city: @application.city, conviction_date_1: @application.conviction_date_1, conviction_date_2: @application.conviction_date_2, conviction_date_3: @application.conviction_date_3, conviction_penalty_1: @application.conviction_penalty_1, conviction_penalty_2: @application.conviction_penalty_2, conviction_penalty_3: @application.conviction_penalty_3, conviction_state_1: @application.conviction_state_1, conviction_state_2: @application.conviction_state_2, conviction_state_3: @application.conviction_state_3, conviction_violation_1: @application.conviction_violation_1, conviction_violation_2: @application.conviction_violation_2, conviction_violation_3: @application.conviction_violation_3, email: @application.email, experience_class_1: @application.experience_class_1, experience_class_2: @application.experience_class_2, experience_class_3: @application.experience_class_3, experience_end_date_1: @application.experience_end_date_1, experience_end_date_2: @application.experience_end_date_2, experience_end_date_3: @application.experience_end_date_3, experience_miles_1: @application.experience_miles_1, experience_miles_2: @application.experience_miles_2, experience_miles_3: @application.experience_miles_3, experience_start_date_1: @application.experience_start_date_1, experience_start_date_2: @application.experience_start_date_2, experience_start_date_3: @application.experience_start_date_3, experience_type_1: @application.experience_type_1, experience_type_2: @application.experience_type_2, experience_type_3: @application.experience_type_3, first_name: @application.first_name, last_name: @application.last_name, license_expiration_date: @application.license_expiration_date, license_number: @application.license_number, license_state: @application.license_state, license_type: @application.license_type, middle_initial: @application.middle_initial, phone_number: @application.phone_number, residency_address_1: @application.residency_address_1, residency_address_2: @application.residency_address_2, residency_address_3: @application.residency_address_3, residency_city_1: @application.residency_city_1, residency_city_2: @application.residency_city_2, residency_city_3: @application.residency_city_3, residency_state_1: @application.residency_state_1, residency_state_2: @application.residency_state_2, residency_state_3: @application.residency_state_3, residency_zip_1: @application.residency_zip_1, residency_zip_2: @application.residency_zip_2, residency_zip_3: @application.residency_zip_3, ssn: @application.ssn, state: @application.state, zip: @application.zip } }
    assert_redirected_to application_url(@application)
  end

  test "should destroy application" do
    assert_difference("Application.count", -1) do
      delete application_url(@application)
    end

    assert_redirected_to applications_url
  end
end
