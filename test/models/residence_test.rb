require "test_helper"

class ResidenceTest < ActiveSupport::TestCase
  test "builds a full address" do
    assert_equal "Greenville, SC, USA", residences(:one).full_address
  end

  test "should_geocode? checks changed location fields outside test mode" do
    residence = Residence.new(user: users(:one), city: "Paris", state: "", country: "France")

    with_rails_env("development") do
      original_user_agent = ENV["GEOCODER_USER_AGENT"]
      begin
        ENV["GEOCODER_USER_AGENT"] = nil
        assert_not residence.send(:should_geocode?)

        ENV["GEOCODER_USER_AGENT"] = "food_mapp/1.0 (test@example.com)"
        assert residence.send(:should_geocode?)
      ensure
        ENV["GEOCODER_USER_AGENT"] = original_user_agent
      end
    end
  end
end
