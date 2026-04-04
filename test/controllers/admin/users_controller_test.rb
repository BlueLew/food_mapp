require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    sign_in_as @admin
  end

  test "should get index" do
    get admin_users_url
    assert_response :success
  end

  test "should get show" do
    get admin_user_url(users(:one))
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_user_url(users(:one))
    assert_response :success
  end
end
