class AdminTransactionForm
  include ActiveModel::Model

  attr_accessor :type, :amount, :details, :order_number, :payer, :outcome_order_id

  validates :type, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :order_number, presence: true
  validates :details, presence: true
  validate :outcome_order_amount, if: :outcome_order


  def outcome_order
    return unless outcome_order_id
    OutcomeOrder.find outcome_order_id
  end

  def income?
    type == 'income'
  end

  def amount_money
    Money.new amount.to_f*100
  end

  private

  def outcome_order_amount
    errors.add :amount, 'Сумма вывода должна совпадать с заявкой' unless amount_money == outcome_order.amount
  end
end
