require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(name: "Test User", email_address: " DOWNCASED@EXAMPLE.COM ", password: "password123", password_confirmation: "password123")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "requires a name" do
    user = User.new(email_address: "person@example.com", password: "password123", password_confirmation: "password123")
    assert_not user.valid?
  end

  test "requires a unique email_address" do
    user = User.new(
      name: "Copy Cat",
      email_address: " AMINA@EXAMPLE.COM ",
      password: "password123",
      password_confirmation: "password123"
    )

    assert_not user.valid?
    assert_includes user.errors[:email_address], "has already been taken"
  end
end
