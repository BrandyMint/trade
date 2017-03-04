require 'test_helper'

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    login users(:manager)
    get admin_root_url
    assert_response :success
  end
end
