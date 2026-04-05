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

  test "should refresh quick stats for turbo frame searches" do
    get venues_url, params: { query: "Anchorage" }, headers: { "Turbo-Frame" => "venues_results" }

    assert_response :success
    assert_includes @response.body, %(id="venues_results")
    assert_includes @response.body, ">1</p>"
    assert_includes @response.body, "venues in the current result set"
    assert_includes @response.body, "likes represented across those venues"
    assert_not_includes @response.body, ">2</p>"
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

  test "should render venue maps without google api attributes" do
    get venue_url(@venue)

    assert_response :success
    assert_includes @response.body, "data-map-tile-url-value="
    assert_includes @response.body, "data-map-attribution-value="
    assert_not_includes @response.body, "data-map-api-key-value="
    assert_not_includes @response.body, "maps.googleapis.com"
  end

  test "venue cards navigate to venue pages outside the list turbo frame" do
    get venues_url

    assert_response :success
    assert_includes @response.body, %(data-turbo-frame="_top")
  end
end
