module Billing
  def self.check!
    raise 'Не соотсветвуют суммы заблокированных средств' unless OpenbillAccount.system_locked.amount == OpenbillLocking.total(:locked)
  end

  def self.income_to_company(user:, company:, amount:, details:, order_number: , payer: )
    OpenbillTransaction.create!(
      user: user,
      from_account: OpenbillAccount.system_income,
      to_account: company.account,
      amount: amount,
      details: details,
      key: "income-#{order_number}",
      meta: { order_number: order_number, payer: payer }
    )
  end

  def self.outcome_from_company(user:, company:, amount:, details:)
    account = company.account.reload
    account.transaction do
      raise "На счету компании не достаточно средств" if account.amount < amount
      OpenbillTransaction.create!(
        user: user,
        from_account: company.account,
        to_account: OpenbillAccount.system_income,
        amount: amount,
        details: details,
        key: 'outcome-' + Time.now.to_s
      )
    end
  end

  # Блокируем на счету компании сумму достаточную для покупки товара
  def self.lock_amount(order)
    user = order.user
    company = order.company
    good = order.good
    base_account = company.account.reload
    fail 'Нельзя покупать у самого себя' if company.id == good.company.id

    base_account.with_lock do
      raise 'Невозможно заблокировать средства для предложения без цены' unless good.amount.present?
      raise "Не хватает средств #{base_account.amount} < #{good.amount}" if base_account.amount < good.amount

      t = OpenbillTransaction.create!(
        user: user,
        from_account: base_account,
        to_account: OpenbillAccount.system_locked,
        key: "lock-for-order:#{order.id}",
        amount: good.amount,
        details: "Блокировка средств для приобретения #{good.id}. Заказ #{order.id}",
        meta: { buyer_company_id: company.id, order_id: order.id, seller_company_id: good.company_id, good_id: good.id }
      )
      OpenbillLocking.create!(
        order: order,
        user: user,
        seller: good.company,
        buyer: company,
        amount: good.amount,
        good: good,
        locking_transaction: t
      )
    end
  end

  # Овобождаем заблокированные средства (возвращаем покупателю)
  def self.free_amount(user:, locking:)
    locking.reload.with_lock do
      raise 'Вернуть можно только заблокированные средства' unless locking.locked?
      t = locking.locking_transaction.reverse! user: user
      locking.update reverse_transaction: t
    end
  end

  # Передаем заблокированные средства покупателю
  def self.buy_amount(user:, locking:)
    locking.reload.with_lock do
      raise 'Сумма блокировки отличается от суммы товара' unless locking.amount == locking.good.reload.amount
      raise 'Разблокировать можно только заблокированные средства' unless locking.locked?
      t = OpenbillTransaction.create!(
        user: user,
        from_account: OpenbillAccount.system_locked,
        to_account: locking.seller.account,
        key: "buy-#{locking.id}",
        amount: locking.amount,
        details: "Покупка #{locking.good_id}",
        meta: {
          good_id: locking.good_id,
          locking_id: locking.id,
          seller_id: locking.seller_id,
          buyer_id: locking.buyer_id,
        }
      )
      locking.update reverse_transaction: t
    end
  end
end
