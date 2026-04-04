require "test_helper"

class VenueTest < ActiveSupport::TestCase
  test "search_for returns ordered venues when blank" do
    assert_equal [ venues(:two), venues(:one) ].sort_by(&:name), Venue.search_for(nil).to_a
  end
end
