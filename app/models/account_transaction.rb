class AccountTransaction
  delegate :id, :company, :created_at, :reverse_transaction_id, :details, :meta, :key, :date, to: :raw_transaction

  def initialize(account_ids, raw_transaction)
    @account_ids = account_ids
    @raw_transaction = raw_transaction
  end

  def incoming?
    account_ids.include? raw_transaction.to_account_id
  end

  def amount
    incoming? ? raw_transaction.amount : -raw_transaction.amount
  end

  def account
    if incoming?
      raw_transaction.to_account
    else
      raw_transaction.from_account
    end
  end

  def opposite_account
    if incoming?
      raw_transaction.from_account
    else
      raw_transaction.to_account
    end
  end

  def opposite_account_id
    opposite_account.id
  end

  private

  attr_reader :account_ids, :raw_transaction
end
