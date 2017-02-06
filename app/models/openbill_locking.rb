class OpenbillLocking < ApplicationRecord
  extend Enumerize

  belongs_to :seller, class_name: 'Company'
  belongs_to :buyer, class_name: 'Company'
  belongs_to :good

  belongs_to :locking_transaction, class_name: 'OpenbillTransaction'
  belongs_to :reverse_transaction, class_name: 'OpenbillTransaction'
  belongs_to :buy_transaction, class_name: 'OpenbillTransaction'

  monetize :amount_cents, as: :amount

  enumerize :state,
    in: %w(locked buy reversed),
    predicates: true,
    scope: true,
    default: 'locked'
end
