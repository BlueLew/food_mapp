require "test_helper"

class ResidenceTest < ActiveSupport::TestCase
  test "builds a full address" do
    assert_equal "Greenville, SC, USA", residences(:one).full_address
  end

  test "should_geocode? checks changed location fields outside test mode" do
    residence = Residence.new(user: users(:one), city: "Paris", state: "", country: "France")

    with_rails_env("development") do
      original_api_key = ENV["GOOGLE_MAPS_API_KEY"]
      ENV["GOOGLE_MAPS_API_KEY"] = "test-key"
      begin
        assert residence.send(:should_geocode?)
      ensure
        ENV["GOOGLE_MAPS_API_KEY"] = original_api_key
      end
    end
  end
end
