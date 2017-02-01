class OpenbillTransaction < OpenbillRecord
  belongs_to :from_account, class_name: 'OpenbillAccount'
  belongs_to :to_account, class_name: 'OpenbillAccount'

  monetize :amount_cents
end

