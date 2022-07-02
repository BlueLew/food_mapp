require 'test_helper'

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should get index,' do
    get admin_users_index, _url
    assert_response :success
  end

  test 'should get edit,' do
    get admin_users_edit, _url
    assert_response :success
  end

  test 'should get update,' do
    get admin_users_update, _url
    assert_response :success
  end

  test 'should get delete' do
    get admin_users_delete_url
    assert_response :success
  end
end
