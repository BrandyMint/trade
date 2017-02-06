module Billing

  # Блокируем на счету компании сумму достаточную для покупки товара
  def lock_amount(company, good)
    base_account = company.account
    fail 'Нельзя покупать у самого себя' if company.id == good.company.id

    base_account.transaction do
      raise "Не хватает средств" unless base_account.amount < good.amount

      transaction = OpenbillTransaction.create!(
        from_account: base_account,
        to_account: OpenbillAccount.system_locked,
        key: "lock-#{company.id}-#{good.id}",
        amount: good.amount,
        details: "Блокировка средств для приобретения #{good.id}",
        meta: { buyer_company_id: company.id, seller_company_id: good.company_id, good_id: good.id }
      )
      OpenbillLocking.create!(
        seller_account: base_account,
        buyer_account: good.company.account,
        amount: good.amount,
        transaction: transaction
      )
    end
  end

  # Овобождаем заблокированные средства (возвращаем покупателю)
  def free_amount(locking)
    transaction = OpenbillTransaction.find transaction_id
    transaction.locked_account.transaction do
      transaction.reverse!
    end
  end

  # Передаем заблокированные средства покупателю
  def buy_amount(locking)
    transaction = OpenbillTransaction.find transaction_id
    transaction.locked_account.transaction do
      transaction.reverse!
      OpenbillTransaction.create!(
        from_account: base_account,
        to_account: company.locked_account,
        key: "#{company.id}-#{good.id}",
        amount: good.amount,
        details: "Блокировка средств для приобретения #{good.id}",
        meta: { good_id: good.id }
      )
    end
  end
end
