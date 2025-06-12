require "application_system_test_case"

class PricingMatricesTest < ApplicationSystemTestCase
  setup do
    @pricing_matrix = pricing_matrices(:one)
  end

  test "visiting the index" do
    visit pricing_matrices_url
    assert_selector "h1", text: "Pricing matrices"
  end

  test "should create pricing matrix" do
    visit pricing_matrices_url
    click_on "New pricing matrix"

    fill_in "End miles", with: @pricing_matrix.end_miles
    fill_in "Price", with: @pricing_matrix.price
    fill_in "Start miles", with: @pricing_matrix.start_miles
    click_on "Create Pricing matrix"

    assert_text "Pricing matrix was successfully created"
    click_on "Back"
  end

  test "should update Pricing matrix" do
    visit pricing_matrix_url(@pricing_matrix)
    click_on "Edit this pricing matrix", match: :first

    fill_in "End miles", with: @pricing_matrix.end_miles
    fill_in "Price", with: @pricing_matrix.price
    fill_in "Start miles", with: @pricing_matrix.start_miles
    click_on "Update Pricing matrix"

    assert_text "Pricing matrix was successfully updated"
    click_on "Back"
  end

  test "should destroy Pricing matrix" do
    visit pricing_matrix_url(@pricing_matrix)
    click_on "Destroy this pricing matrix", match: :first

    assert_text "Pricing matrix was successfully destroyed"
  end
end
