require "test_helper"

class PricingMatricesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pricing_matrix = pricing_matrices(:one)
  end

  test "should get index" do
    get pricing_matrices_url
    assert_response :success
  end

  test "should get new" do
    get new_pricing_matrix_url
    assert_response :success
  end

  test "should create pricing_matrix" do
    assert_difference("PricingMatrix.count") do
      post pricing_matrices_url, params: { pricing_matrix: { end_miles: @pricing_matrix.end_miles, price: @pricing_matrix.price, start_miles: @pricing_matrix.start_miles } }
    end

    assert_redirected_to pricing_matrix_url(PricingMatrix.last)
  end

  test "should show pricing_matrix" do
    get pricing_matrix_url(@pricing_matrix)
    assert_response :success
  end

  test "should get edit" do
    get edit_pricing_matrix_url(@pricing_matrix)
    assert_response :success
  end

  test "should update pricing_matrix" do
    patch pricing_matrix_url(@pricing_matrix), params: { pricing_matrix: { end_miles: @pricing_matrix.end_miles, price: @pricing_matrix.price, start_miles: @pricing_matrix.start_miles } }
    assert_redirected_to pricing_matrix_url(@pricing_matrix)
  end

  test "should destroy pricing_matrix" do
    assert_difference("PricingMatrix.count", -1) do
      delete pricing_matrix_url(@pricing_matrix)
    end

    assert_redirected_to pricing_matrices_url
  end
end
