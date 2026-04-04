require "test_helper"

class LikeTest < ActiveSupport::TestCase
  test "enforces unique user venue pairs" do
    like = Like.new(user: users(:one), venue: venues(:one))
    assert_not like.valid?
  end
end
