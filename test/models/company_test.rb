require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  test "create company from fixture" do
    assert companies(:one)
  end

  test "manual create company" do
    company = Company.create name: 'one', inn: '123', ogrn: '345', user: users(:one)

    assert company.persisted?
  end
end
