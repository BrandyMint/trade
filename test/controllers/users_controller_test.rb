require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should post not create" do
    post users_path, params: { user: { email: '' } }
    assert_response :success
  end

  test "should post create" do
    assert_difference -> { User.count } do
      post users_path,
        params: { user: { email: 'test@email.ru', phone: '+79033891220', name: 'Danil', password: '123', password_confirmation: '123' } }
    end
    assert_response :redirect
  end

  test "should get edit" do
    user = users :one
    login user
    get edit_user_url user
    assert_response :success
  end

  test "should get update" do
    user = users :one
    login user
    patch user_url user, params: { user: { email: 'aaa@bbb.ru' }}
    assert_response :success
  end
end
