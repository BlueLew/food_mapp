require "test_helper"

class VenuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @venue = venues(:one)
  end

  test "should get index" do
    get venues_url
    assert_response :success
  end

  test "should filter venues by query" do
    get venues_url, params: { query: "Anchorage" }
    assert_response :success
    assert_includes @response.body, @venue.name
  end

  test "should show venue" do
    get venue_url(@venue)
    assert_response :success
  end

  test "should show venue with signed in user like state" do
    post session_url, params: { email_address: users(:one).email_address, password: "password123" }

    get venue_url(@venue)

    assert_response :success
    assert_includes @response.body, "Unlike venue"
  end

  test "should render index with signed in user like state" do
    post session_url, params: { email_address: users(:one).email_address, password: "password123" }

    get venues_url

    assert_response :success
    assert_includes @response.body, "Unlike venue"
    assert_includes @response.body, "Like venue"
  end

  test "should skip map markers for records without coordinates" do
    venue = Venue.create!(name: "No Coordinates Cafe", address: "123 Missing St, Greenville, SC", category: "Cafe")

    get venue_url(venue)

    assert_response :success
    assert_includes @response.body, "data-map-markers-value=\"[]\""
  end
end
