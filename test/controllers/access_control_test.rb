require "test_helper"

class AccessControlTest < ActionDispatch::IntegrationTest
  test "unauthenticated users are redirected to sign in and then back to the requested page" do
    get profile_url

    assert_redirected_to new_session_url

    post session_url, params: { email_address: users(:one).email_address, password: "password123" }

    assert_redirected_to profile_url
  end

  test "non-admin users are redirected away from admin pages" do
    sign_in_as users(:one)

    get admin_users_url

    assert_redirected_to root_url
    follow_redirect!
    assert_match "You are not authorized to access that page.", @response.body
  end
end
