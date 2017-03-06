require 'test_helper'

class Admin::LockingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    login users(:manager)
    get admin_lockings_path
    assert_response :success
  end
end
