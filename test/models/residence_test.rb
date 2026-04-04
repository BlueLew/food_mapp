require "test_helper"

class ResidenceTest < ActiveSupport::TestCase
  test "builds a full address" do
    assert_equal "Greenville, SC, USA", residences(:one).full_address
  end
end
