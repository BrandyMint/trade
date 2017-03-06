require 'test_helper'

class UserTransactionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    login users(:one)
    get user_transactions_path
    assert_response :success
  end

  test "should get show" do
    login users(:one)
    get user_transaction_path(openbill_transactions(:one))
    assert_response :success
  end
end
