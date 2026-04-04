require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "new" do
    get new_registration_url
    assert_response :success
  end

  test "create" do
    assert_difference("User.count") do
      post registration_url, params: {
        user: {
          name: "New User",
          email_address: "new@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_redirected_to root_url
  end
end
