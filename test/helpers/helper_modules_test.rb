require "test_helper"

class HelperModulesTest < ActiveSupport::TestCase
  test "autoloads helper modules" do
    assert_kind_of Module, ProfilesHelper
    assert_kind_of Module, ResidencesHelper
    assert_kind_of Module, VenuesHelper
    assert_kind_of Module, Admin::UsersHelper
    assert_kind_of Module, Admin::VenuesHelper
  end
end
