class OpenbillLocking < ApplicationRecord
  belongs_to :seller_account, class_name: 'OpenbillAccount'
  belongs_to :buyer_account, class_name: 'OpenbillAccount'

  monetize :amount_cents, as: :amount
end
