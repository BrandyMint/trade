require 'test_helper'

class UserTransactionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_transactions_index_url
    assert_response :success
  end

  test "should get new" do
    get user_transactions_new_url
    assert_response :success
  end

  test "should get show" do
    get user_transactions_show_url
    assert_response :success
  end

end
