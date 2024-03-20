require "application_system_test_case"

class InquiriesTest < ApplicationSystemTestCase
  setup do
    @inquiry = inquiries(:one)
  end

  test "visiting the index" do
    visit inquiries_url
    assert_selector "h1", text: "Inquiries"
  end

  test "should create inquiry" do
    visit inquiries_url
    click_on "New inquiry"

    fill_in "Email address", with: @inquiry.email_address
    fill_in "Message", with: @inquiry.message
    fill_in "Name", with: @inquiry.name
    fill_in "Phone number", with: @inquiry.phone_number
    click_on "Create Inquiry"

    assert_text "Inquiry was successfully created"
    click_on "Back"
  end

  test "should update Inquiry" do
    visit inquiry_url(@inquiry)
    click_on "Edit this inquiry", match: :first

    fill_in "Email address", with: @inquiry.email_address
    fill_in "Message", with: @inquiry.message
    fill_in "Name", with: @inquiry.name
    fill_in "Phone number", with: @inquiry.phone_number
    click_on "Update Inquiry"

    assert_text "Inquiry was successfully updated"
    click_on "Back"
  end

  test "should destroy Inquiry" do
    visit inquiry_url(@inquiry)
    click_on "Destroy this inquiry", match: :first

    assert_text "Inquiry was successfully destroyed"
  end
end
