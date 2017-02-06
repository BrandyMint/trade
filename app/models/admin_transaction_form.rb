class AdminTransactionForm
  include ActiveModel::Model

  attr_accessor :type, :amount, :details

  validates :type, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }

  def income?
    type == 'income'
  end

  def amount_money
    Money.new amount.to_f*100
  end
end
