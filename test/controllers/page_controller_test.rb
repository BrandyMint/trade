require 'test_helper'

class PageControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get page_path pages(:one)
    assert_response :success
  end
end
