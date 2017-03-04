require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  test "create company from fixture" do
    assert companies(:one)
  end
end
