module Billing
  def self.check!
    raise 'Не соотсветвуют суммы заблокированных средств' unless OpenbillAccount.system_locked.amount == OpenbillLocking.total(:locked)
  end

  def self.income_to_company(company, amount, details = nil)
    OpenbillTransaction.create!(
      from_account: OpenbillAccount.system_income,
      to_account: company.account,
      amount: amount,
      details: details,
      key: 'income-' + Time.now.to_s
    )
  end

  def self.outcome_from_company(company, amount, details = nil)
    account = company.account.reload
    account.transaction do
      raise "На счету компании не достаточно средств" if account.amount < amount
      OpenbillTransaction.create!(
        from_account: company.account,
        to_account: OpenbillAccount.system_income,
        amount: amount,
        details: details,
        key: 'outcome-' + Time.now.to_s
      )
    end
  end

  # Блокируем на счету компании сумму достаточную для покупки товара
  def self.lock_amount(company, good)
    base_account = company.account.reload
    fail 'Нельзя покупать у самого себя' if company.id == good.company.id

    base_account.with_lock do
      raise 'Невозможно заблокировать средства для предложения без цены' unless good.amount.present?
      raise "Не хватает средств #{base_account.amount} < #{good.amount}" if base_account.amount < good.amount

      t = OpenbillTransaction.create!(
        from_account: base_account,
        to_account: OpenbillAccount.system_locked,
        key: "lock-#{company.id}-#{good.id}-#{Time.now.to_i}",
        amount: good.amount,
        details: "Блокировка средств для приобретения #{good.id}",
        meta: { buyer_company_id: company.id, seller_company_id: good.company_id, good_id: good.id }
      )
      OpenbillLocking.create!(
        seller: good.company,
        buyer: company,
        amount: good.amount,
        good: good,
        locking_transaction: t
      )
    end
  end

  # Овобождаем заблокированные средства (возвращаем покупателю)
  def self.free_amount(locking)
    locking.reload.with_lock do
      raise 'Вернуть можно только заблокированные средства' unless locking.state == 'locked'
      t = locking.locking_transaction.reverse!
      locking.update reverse_transaction: t
    end
  end

  # Передаем заблокированные средства покупателю
  def self.buy_amount(locking)
    locking.reload.with_lock do
      raise 'Сумма блокировки отличается от суммы товара' unless locking.amount == locking.good.reload.amount
      raise 'Разблокировать можно только заблокированные средства' unless locking.locked?
      t = OpenbillTransaction.create!(
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
