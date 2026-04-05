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

  test "should filter index by query" do
    get admin_users_url, params: { query: "Admin" }

    assert_response :success
    assert_includes @response.body, @admin.name
    assert_not_includes @response.body, users(:one).name
  end

  test "should get show" do
    get admin_user_url(users(:one))
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_user_url(users(:one))
    assert_response :success
  end

  test "should update user" do
    patch admin_user_url(users(:one)), params: { user: { name: "Updated Member", email_address: "updated-member@example.com", role: "member" } }

    assert_redirected_to admin_user_url(users(:one))
    assert_equal "Updated Member", users(:one).reload.name
  end

  test "should render edit when update is invalid" do
    patch admin_user_url(users(:one)), params: { user: { name: "", email_address: "updated-member@example.com", role: "member" } }

    assert_response :unprocessable_content
  end

  test "should render edit when email is already taken" do
    patch admin_user_url(users(:one)), params: {
      user: {
        name: "Updated Member",
        email_address: users(:two).email_address.upcase,
        role: "member"
      }
    }

    assert_response :unprocessable_content
    assert_includes @response.body, "Email address has already been taken"
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete admin_user_url(users(:two))
    end

    assert_redirected_to admin_users_url
  end

  test "should not destroy the last admin user" do
    assert_no_difference("User.count") do
      delete admin_user_url(@admin)
    end

    assert_redirected_to admin_user_url(@admin)
    assert_equal "You cannot delete the last admin account.", flash[:alert]
  end
end
