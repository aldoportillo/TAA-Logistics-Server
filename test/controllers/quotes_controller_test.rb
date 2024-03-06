require "test_helper"

class QuotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @quote = quotes(:one)
  end

  test "should get index" do
    get quotes_url
    assert_response :success
  end

  test "should get new" do
    get new_quote_url
    assert_response :success
  end

  test "should create quote" do
    assert_difference("Quote.count") do
      post quotes_url, params: { quote: { CS: @quote.CS, commodity: @quote.commodity, commodity_gross_weight: @quote.commodity_gross_weight, commodity_temp: @quote.commodity_temp, company_name: @quote.company_name, contact_name: @quote.contact_name, container_size: @quote.container_size, delivery_date: @quote.delivery_date, delivery_zip_code: @quote.delivery_zip_code, email: @quote.email, equipment_type: @quote.equipment_type, fax: @quote.fax, from: @quote.from, pallets: @quote.pallets, phone: @quote.phone, questions_or_notes: @quote.questions_or_notes, rail_destination: @quote.rail_destination, shipping_date: @quote.shipping_date, shipping_zip_code: @quote.shipping_zip_code } }
    end

    assert_redirected_to quote_url(Quote.last)
  end

  test "should show quote" do
    get quote_url(@quote)
    assert_response :success
  end

  test "should get edit" do
    get edit_quote_url(@quote)
    assert_response :success
  end

  test "should update quote" do
    patch quote_url(@quote), params: { quote: { CS: @quote.CS, commodity: @quote.commodity, commodity_gross_weight: @quote.commodity_gross_weight, commodity_temp: @quote.commodity_temp, company_name: @quote.company_name, contact_name: @quote.contact_name, container_size: @quote.container_size, delivery_date: @quote.delivery_date, delivery_zip_code: @quote.delivery_zip_code, email: @quote.email, equipment_type: @quote.equipment_type, fax: @quote.fax, from: @quote.from, pallets: @quote.pallets, phone: @quote.phone, questions_or_notes: @quote.questions_or_notes, rail_destination: @quote.rail_destination, shipping_date: @quote.shipping_date, shipping_zip_code: @quote.shipping_zip_code } }
    assert_redirected_to quote_url(@quote)
  end

  test "should destroy quote" do
    assert_difference("Quote.count", -1) do
      delete quote_url(@quote)
    end

    assert_redirected_to quotes_url
  end
end
