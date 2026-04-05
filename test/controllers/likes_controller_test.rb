require "test_helper"

class LikesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @venue = venues(:two)
    sign_in_as @user
  end

  test "create" do
    assert_difference("Like.count") do
      post venue_like_url(@venue)
    end

    assert_redirected_to venue_url(@venue)
  end

  test "create updates venue stats over turbo stream" do
    assert_difference("Like.count") do
      post venue_like_url(@venue), as: :turbo_stream
    end

    assert_response :success
    assert_equal Mime[:turbo_stream].to_s, response.media_type
    assert_includes response.body, %(target="like_toggle_venue_#{@venue.id}")
    assert_includes response.body, %(target="like_count_venue_#{@venue.id}")
    assert_includes response.body, %(target="quick_stats_venue_#{@venue.id}")
    assert_includes response.body, %(target="origin_breakdowns_venue_#{@venue.id}")
    assert_includes response.body, %(target="venues_quick_stats")
    assert_includes response.body, ">2</p>"
    assert_includes response.body, "Greenville"
  end

  test "destroy" do
    like = likes(:one)
    sign_in_as like.user

    assert_difference("Like.count", -1) do
      delete venue_like_url(like.venue)
    end

    assert_redirected_to venue_url(like.venue)
  end

  test "destroy updates venue stats over turbo stream" do
    like = likes(:one)
    sign_in_as like.user

    assert_difference("Like.count", -1) do
      delete venue_like_url(like.venue), as: :turbo_stream
    end

    assert_response :success
    assert_equal Mime[:turbo_stream].to_s, response.media_type
    assert_includes response.body, %(target="like_toggle_venue_#{like.venue.id}")
    assert_includes response.body, %(target="like_count_venue_#{like.venue.id}")
    assert_includes response.body, %(target="quick_stats_venue_#{like.venue.id}")
    assert_includes response.body, %(target="origin_breakdowns_venue_#{like.venue.id}")
    assert_includes response.body, %(target="venues_quick_stats")
    assert_includes response.body, ">0</p>"
    assert_includes response.body, "No residence data yet."
  end
end
