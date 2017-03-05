require 'test_helper'

class BillingTet < ActiveSupport::TestCase
  test "fixture" do
    assert openbill_accounts(:full)
  end

  test "income and outcome" do
    amount = Money.new(1000)
    Billing.income_to_company(
      user: users(:one),
      company: companies(:one),
      amount: amount,
      details: 'Детали',
      order_number: '123',
      payer: '123'
    )

    assert_equal OpenbillAccount.system_income.reload.amount, -amount
    assert_equal companies(:one).account.reload.amount, amount

    outcome = Money.new(600)
    Billing.outcome_from_company(
      user: users(:one),
      company: companies(:one),
      amount: outcome,
      details: ''
    )
    assert_equal OpenbillAccount.system_income.reload.amount, -amount + outcome
    assert_equal companies(:one).account.reload.amount, amount - outcome
  end

  test "lock amount" do
    Billing.income_to_company(
      company: companies(:one),
      amount: goods(:two).amount,
      user: users(:one),
      details: 'Детали',
      order_number: '123',
      payer: '123'
    )

    order = Order.create(
      user: users(:one),
      company: companies(:one),
      good: goods(:two)
    )
    locking = Billing.lock_amount(order)

    assert_equal companies(:one).account.reload.amount, 0
    assert locking.is_a? OpenbillLocking

    Billing.free_amount(
      user: users(:one),
      locking: locking
    )

    assert_equal companies(:one).account.reload.amount, goods(:two).amount
  end

  test "buy amount" do
    Billing.income_to_company(
      company: companies(:one),
      amount: goods(:two).amount,
      user: users(:one),
      details: 'Детали',
      order_number: '1234',
      payer: '123'
    )
    order = Order.create(
      user: users(:one),
      company: companies(:one),
      good: goods(:two)
    )
    locking = Billing.lock_amount(order)

    assert_equal companies(:one).account.reload.amount, 0
    assert locking.is_a? OpenbillLocking

    Billing.buy_amount(
      user: users(:one),
      locking: locking
    )

    assert_equal companies(:one).account.reload.amount, 0
    assert_equal goods(:two).company.account.reload.amount, locking.amount
  end
end
