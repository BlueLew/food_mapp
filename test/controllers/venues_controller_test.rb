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
end
