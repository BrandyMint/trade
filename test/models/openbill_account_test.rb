require 'test_helper'

class OpenbillAccountTest < ActiveSupport::TestCase
   test "account exists" do
     assert openbill_accounts(:one)
   end
end
