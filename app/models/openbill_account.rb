class OpenbillAccount < OpenbillRecord
  belongs_to :category, class_name: 'OpenbillCategory'
  has_one :company, foreign_key: 'account_id'

  monetize :amount_cents, as: :amount

  before_create :set_defaults

  def self.system_income
    find_or_create_by(name: 'Входящий', category: OpenbillCategory.system)
  end

  def self.system_locked
    find_or_create_by(name: 'Заблокированные средства', category: OpenbillCategory.system)
  end

  def to_s
    company.to_s
  end

  private

  def set_defaults
    self.amount_currency = 'RUB'
  end
end
