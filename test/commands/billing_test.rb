require 'test_helper'

class BillingTet < ActiveSupport::TestCase
  test "fixture" do
    assert openbill_accounts(:one)
  end

  test "income and outcome" do
    amount = Money.new(1000)
    Billing.income_to_company companies(:one), amount

    assert_equal OpenbillAccount.system_income.reload.amount, -amount
    assert_equal companies(:one).account.reload.amount, amount

    outcome = Money.new(600)
    Billing.outcome_from_company companies(:one), outcome
    assert_equal OpenbillAccount.system_income.reload.amount, -amount + outcome
    assert_equal companies(:one).account.reload.amount, amount - outcome
  end

  test "lock amount" do
    Billing.income_to_company companies(:one), goods(:two).amount
    locking = Billing.lock_amount companies(:one), goods(:two)

    assert_equal companies(:one).account.reload.amount, 0
    assert locking.is_a? OpenbillLocking

    Billing.free_amount locking

    assert_equal companies(:one).account.reload.amount, goods(:two).amount
  end

  test "buy amount" do
    Billing.income_to_company companies(:one), goods(:two).amount
    locking = Billing.lock_amount companies(:one), goods(:two)

    assert_equal companies(:one).account.reload.amount, 0
    assert locking.is_a? OpenbillLocking

    Billing.buy_amount locking

    assert_equal companies(:one).account.reload.amount, 0
    assert_equal goods(:two).company.account.reload.amount, locking.amount
  end
end
