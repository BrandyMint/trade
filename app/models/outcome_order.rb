class OutcomeOrder < ApplicationRecord
  belongs_to :user
  belongs_to :company
  belongs_to :requisite
  # belongs_to :transaction, class_name: 'OpenbillTransaction', foreign_key: :transaction_uuid
  belongs_to :manager, class_name: 'User'
end
