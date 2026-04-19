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

  test "create renders new for invalid data" do
    assert_no_difference("User.count") do
      post registration_url, params: {
        user: {
          name: "",
          email_address: "broken@example.com",
          password: "password123",
          password_confirmation: "mismatch"
        }
      }
    end

    assert_response :unprocessable_content
  end

  test "create renders validation errors for duplicate email" do
    assert_no_difference("User.count") do
      post registration_url, params: {
        user: {
          name: "Copy User",
          email_address: "AMINA@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_response :unprocessable_content
    assert_includes @response.body, "Email address has already been taken"
  end

  test "create renders validation errors for a short password" do
    assert_no_difference("User.count") do
      post registration_url, params: {
        user: {
          name: "New User",
          email_address: "new@example.com",
          password: "short",
          password_confirmation: "short"
        }
      }
    end

    assert_response :unprocessable_content
    assert_includes @response.body, "Password is too short"
  end
end
