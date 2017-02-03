class OpenbillAccount < OpenbillRecord
  belongs_to :category, class_name: 'OpenbillCategory'
  has_one :company, foreign_key: 'account_id'

  monetize :amount_cents

  before_create :set_defaults

  def to_s
    company.to_s
  end

  private

  def set_defaults
    self.amount_currency = 'RUB'
  end
end
