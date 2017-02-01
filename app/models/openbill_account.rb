class OpenbillAccount < OpenbillRecord
  belongs_to :category, class_name: 'OpenbillCategory'
  has_one :company, foreign_key: 'account_id'

  monetize :amount_cents

  def to_s
    company.to_s
  end
end
