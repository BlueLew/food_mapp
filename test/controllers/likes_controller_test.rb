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

  test "destroy" do
    like = likes(:one)
    sign_in_as like.user

    assert_difference("Like.count", -1) do
      delete venue_like_url(like.venue)
    end

    assert_redirected_to venue_url(like.venue)
  end
end
