require 'test_helper'

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  fixtures :users

  test "should get new" do
    get new_password_reset_path
    assert_response :success
  end

  test "should get create" do
    post password_resets_path
    assert_response :success
  end

  test "should get edit" do
    get edit_password_reset_path(users(:one).reset_password_token)
    assert_response :redirect
  end
end
