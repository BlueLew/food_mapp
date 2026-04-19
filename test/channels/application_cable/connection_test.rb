require "test_helper"

class ApplicationCable::ConnectionTest < ActionCable::Connection::TestCase
  tests ApplicationCable::Connection

  test "connects with a valid session cookie" do
    session = users(:one).sessions.create!
    cookies.signed[:session_id] = session.id

    connect

    assert_equal users(:one), connection.current_user
  end

  test "rejects an invalid connection without a session cookie" do
    assert_reject_connection { connect }
  end
end
