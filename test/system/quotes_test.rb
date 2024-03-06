require "application_system_test_case"

class QuotesTest < ApplicationSystemTestCase
  setup do
    @quote = quotes(:one)
  end

  test "visiting the index" do
    visit quotes_url
    assert_selector "h1", text: "Quotes"
  end

  test "should create quote" do
    visit quotes_url
    click_on "New quote"

    fill_in "Cs", with: @quote.CS
    fill_in "Commodity", with: @quote.commodity
    fill_in "Commodity gross weight", with: @quote.commodity_gross_weight
    fill_in "Commodity temp", with: @quote.commodity_temp
    fill_in "Company name", with: @quote.company_name
    fill_in "Contact name", with: @quote.contact_name
    fill_in "Container size", with: @quote.container_size
    fill_in "Delivery date", with: @quote.delivery_date
    fill_in "Delivery zip code", with: @quote.delivery_zip_code
    fill_in "Email", with: @quote.email
    fill_in "Equipment type", with: @quote.equipment_type
    fill_in "Fax", with: @quote.fax
    fill_in "From", with: @quote.from
    fill_in "Pallets", with: @quote.pallets
    fill_in "Phone", with: @quote.phone
    fill_in "Questions or notes", with: @quote.questions_or_notes
    fill_in "Rail destination", with: @quote.rail_destination
    fill_in "Shipping date", with: @quote.shipping_date
    fill_in "Shipping zip code", with: @quote.shipping_zip_code
    click_on "Create Quote"

    assert_text "Quote was successfully created"
    click_on "Back"
  end

  test "should update Quote" do
    visit quote_url(@quote)
    click_on "Edit this quote", match: :first

    fill_in "Cs", with: @quote.CS
    fill_in "Commodity", with: @quote.commodity
    fill_in "Commodity gross weight", with: @quote.commodity_gross_weight
    fill_in "Commodity temp", with: @quote.commodity_temp
    fill_in "Company name", with: @quote.company_name
    fill_in "Contact name", with: @quote.contact_name
    fill_in "Container size", with: @quote.container_size
    fill_in "Delivery date", with: @quote.delivery_date
    fill_in "Delivery zip code", with: @quote.delivery_zip_code
    fill_in "Email", with: @quote.email
    fill_in "Equipment type", with: @quote.equipment_type
    fill_in "Fax", with: @quote.fax
    fill_in "From", with: @quote.from
    fill_in "Pallets", with: @quote.pallets
    fill_in "Phone", with: @quote.phone
    fill_in "Questions or notes", with: @quote.questions_or_notes
    fill_in "Rail destination", with: @quote.rail_destination
    fill_in "Shipping date", with: @quote.shipping_date
    fill_in "Shipping zip code", with: @quote.shipping_zip_code
    click_on "Update Quote"

    assert_text "Quote was successfully updated"
    click_on "Back"
  end

  test "should destroy Quote" do
    visit quote_url(@quote)
    click_on "Destroy this quote", match: :first

    assert_text "Quote was successfully destroyed"
  end
end
