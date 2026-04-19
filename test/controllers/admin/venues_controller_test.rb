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

  test "should filter venues by query" do
    get admin_venues_url, params: { query: "Anchorage" }

    assert_response :success
    assert_includes @response.body, @venue.name
    assert_not_includes @response.body, venues(:two).name
  end

  test "should get show" do
    get admin_venue_url(@venue)
    assert_response :success
  end

  test "should get new" do
    get new_admin_venue_url
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_venue_url(@venue)
    assert_response :success
  end

  test "should create venue" do
    assert_difference("Venue.count") do
      post admin_venues_url, params: { venue: { name: "New Venue", address: "123 Main St, Greenville, SC", category: "Cafe", phone: "123", website: "https://example.com" } }
    end

    assert_redirected_to admin_venue_url(Venue.order(:created_at).last)
  end

  test "should render new when create is invalid" do
    assert_no_difference("Venue.count") do
      post admin_venues_url, params: { venue: { name: "", address: "", category: "" } }
    end

    assert_response :unprocessable_content
  end

  test "should update venue" do
    patch admin_venue_url(@venue), params: { venue: { name: "Updated Venue", address: @venue.address, category: @venue.category } }

    assert_redirected_to admin_venue_url(@venue)
    assert_equal "Updated Venue", @venue.reload.name
  end

  test "should render edit when update is invalid" do
    patch admin_venue_url(@venue), params: { venue: { name: "", address: @venue.address, category: @venue.category } }

    assert_response :unprocessable_content
  end

  test "should destroy venue" do
    assert_difference("Venue.count", -1) do
      delete admin_venue_url(@venue)
    end

    assert_redirected_to admin_venues_url
  end
end
