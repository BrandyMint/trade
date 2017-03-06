require 'test_helper'

class Admin::OrdersControllerTest < ActionDispatch::IntegrationTest
  def setup
    login users(:manager)
  end

  test "should get index" do
    get admin_orders_path
    assert_response :success
  end

  test 'should show' do
    get admin_order_path orders(:one)
    assert_response :success
  end

  test 'complete' do
    patch complete_admin_order_path orders(:one)
    assert_response :redirect
    follow_redirect!
  end

  test 'cancel' do
    patch cancel_admin_order_path orders(:one)
    assert_response :redirect
    follow_redirect!
  end
end
