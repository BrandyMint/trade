require 'test_helper'

class Admin::CompaniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company = companies(:two)
    login users(:manager)
  end

  test "should get index" do
    get companies_url
    assert_response :success
  end

  test "should show company" do
    get company_url(@company)
    assert_response :success
  end

  test "should review company" do
    patch start_review_admin_company_url(@company)
    assert_redirected_to admin_company_url(@company)
    assert @company.reload.being_reviewed?

    patch reject_admin_company_url(@company),
      params: { company: { reject_message: 'test' }}
    assert_redirected_to admin_company_url(@company)
    assert @company.reload.rejected?

    patch start_review_admin_company_url(@company)
    assert_redirected_to admin_company_url(@company)
    assert @company.reload.being_reviewed?

    patch accept_admin_company_url(@company)
    assert_redirected_to admin_company_url(@company)
    assert @company.reload.accepted?
  end
end
