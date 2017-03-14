class OpenbillTransaction < OpenbillRecord
  belongs_to :from_account, class_name: 'OpenbillAccount'
  belongs_to :to_account, class_name: 'OpenbillAccount'
  belongs_to :reverse_transaction, class_name: 'OpenbillTransaction'
  belongs_to :user
  belongs_to :outcome_order

  has_one :reversation_transaction, class_name: 'OpenbillTransaction'

  scope :ordered, -> { order created_at: :desc }

  monetize :amount_cents, as: :amount
  validates :amount, money: { greater_than: 0 }

  validate :outcome_order_amount, if: :outcome_order

  after_create :notify

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

  private

  def outcome_order_amount
    errors.add :amount, 'Сумма вывода должна совпадать с заявкой' unless amount == outcome_order.amount
  end

  def notify
    TransactionMailer.income(self, to_account.company.user).deliver_later! if to_account.company.present?
    TransactionMailer.outcome(self, from_account.company.user).deliver_later! if from_account.company.present?
  end
end
