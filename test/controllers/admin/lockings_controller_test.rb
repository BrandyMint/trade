class Admin::LockingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_lockings_path
    assert_response :success
  end
end
