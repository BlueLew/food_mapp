require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test "show" do
    get profile_url
    assert_response :success
  end

  test "edit" do
    get edit_profile_url
    assert_response :success
  end

  test "update" do
    patch profile_url, params: { user: { name: "Updated Name", email_address: "updated@example.com" } }

    assert_redirected_to profile_url
    assert_equal "Updated Name", users(:one).reload.name
  end

  test "update renders edit for invalid data" do
    patch profile_url, params: { user: { name: "", email_address: "updated@example.com" } }

    assert_response :unprocessable_content
  end

  test "update renders edit for duplicate email" do
    patch profile_url, params: { user: { name: "Updated Name", email_address: users(:two).email_address.upcase } }

    assert_response :unprocessable_content
    assert_includes @response.body, "Email address has already been taken"
  end
end
