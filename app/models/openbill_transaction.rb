class OpenbillTransaction < OpenbillRecord
  belongs_to :from_account, class_name: 'OpenbillAccount'
  belongs_to :to_account, class_name: 'OpenbillAccount'
  belongs_to :reverse_transaction, class_name: 'OpenbillTransaction'
  belongs_to :user

  has_one :reversation_transaction, class_name: 'OpenbillTransaction'

  scope :ordered, -> { order created_at: :desc }

  monetize :amount_cents, as: :amount

  def income?(account = nil)
    account ||= company.account
    to_account_id == account.id
  end

  def outcome?
    !income?
  end

  def opposite_account(account = nil)
    account ||= company.account
    to_account_id == account.id ? from_account : to_account
  end

  def company
    Company.find_by_id meta[:company_id]
  end

  def reverse!(user: )
    fail 'alreade reversed' if reverse_transaction_id.present?
    reverse_transaction = self.class.new
    reverse_transaction.user = user
    reverse_transaction.amount = amount
    reverse_transaction.from_account_id = to_account_id
    reverse_transaction.to_account_id = from_account_id
    reverse_transaction.key = key + '-reverse'
    reverse_transaction.date = date
    reverse_transaction.details = "Reverse of #{details}"
    reverse_transaction.save!

    reverse_transaction
  end
end
