require 'test_helper'

class CompaniesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get companies_path
    assert_response :success
  end

  test 'should get show' do
    get company_path companies(:one)
    assert_response :success
  end

  test "should get new" do
    login users(:one)
    get new_company_path
    assert_response :success
  end

  test "should create new" do
    login users(:one)
    assert_difference -> { Company.count } do
      post companies_path, params: { company: {
        name: 'test',
        inn: '7883296551',
        ogrn: '1162130066526',
        kpp: '472601001',
        email: 'danil@brandymint.ru',
        phone: '+79033891228'
      } }
    end
    assert_response :success
  end

  test 'should edit company' do
    login users(:one)
    get edit_company_path companies(:one_draft)
    assert_response :success
  end

  test 'should update company' do
    login users(:one)
    patch company_path(companies(:one_draft)), params: { company: { title: '123' } }
    assert_response :success
  end
end
