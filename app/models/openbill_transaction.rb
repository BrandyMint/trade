class OpenbillTransaction < OpenbillRecord
  belongs_to :from_account, class_name: 'OpenbillAccount'
  belongs_to :to_account, class_name: 'OpenbillAccount'

  has_one :reversation_transaction, class_name: 'OpenbillTransaction'
  belongs_to :reverse_transaction, class_name: 'OpenbillTransaction'

  monetize :amount_cents, as: :amount

  def reverse!
    fail 'alreade reversed' if reverse_transaction_id.present?
    reverse_transaction = self.class.new
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
