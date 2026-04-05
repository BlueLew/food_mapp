require "test_helper"

class VenueTest < ActiveSupport::TestCase
  test "search_for returns ordered venues when blank" do
    assert_equal [ venues(:two), venues(:one) ].sort_by(&:name), Venue.search_for(nil).to_a
  end

  test "search_for returns matches when query is present" do
    assert_equal [ venues(:one) ], Venue.search_for("Anchorage").to_a
  end

  test "likes_by groups liked residences by attribute" do
    assert_equal [ { name: "Greenville", likes: 1 } ], venues(:one).likes_by(:city)
  end

  test "should_geocode? is false in the test environment" do
    venue = Venue.new(name: "Test Venue", address: "123 Main St, Greenville, SC", category: "Cafe")

    assert_not venue.send(:should_geocode?)
  end
end
