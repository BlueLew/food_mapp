require "test_helper"

class Admin::VenuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @venue = venues(:one)
    sign_in_as @admin
  end

  test "should get index" do
    get admin_venues_url
    assert_response :success
  end

  test "should get show" do
    get admin_venue_url(@venue)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_venue_url(@venue)
    assert_response :success
  end
end
