class Admin::OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_orders_path
    assert_response :success
  end
end
