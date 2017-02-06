class OpenbillAccount < OpenbillRecord
  SYSTEM_INCOME_UUID = '41011e50-5667-49b7-9a0f-6cbde7d9d22c'
  SYSTEM_LOCKED_UUID = '41011e50-5667-49b7-9a0f-6cbde7d9d22b'
  belongs_to :category, class_name: 'OpenbillCategory'
  has_one :company, foreign_key: 'account_id'

  monetize :amount_cents, as: :amount

  before_create :set_defaults

  def self.system_income
    find_by(id: SYSTEM_INCOME_UUID) || create(id: SYSTEM_INCOME_UUID, details: 'Входящий', owner_id: 1, category: OpenbillCategory.system)
  end

  def self.system_locked
    find_by(id: SYSTEM_LOCKED_UUID) || create(id: SYSTEM_LOCKED_UUID, details: 'Заблокированные средства', owner_id: 1, category: OpenbillCategory.system)
  end

  def all_transactions
    OpenbillTransaction.where('from_account_id = ? or to_account_id = ?', id, id)
  end

  def to_s
    company.to_s.presence || details
  end

  private

  def set_defaults
    self.amount_currency = 'RUB'
  end
end
