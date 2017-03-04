class OpenbillLocking < ApplicationRecord
  extend ActiveSupport::Concern
  include Workflow

  belongs_to :seller, class_name: 'Company'
  belongs_to :buyer, class_name: 'Company'
  belongs_to :good
  belongs_to :user

  belongs_to :locking_transaction, class_name: 'OpenbillTransaction'
  belongs_to :reverse_transaction, class_name: 'OpenbillTransaction'
  belongs_to :buy_transaction, class_name: 'OpenbillTransaction'

  workflow do
    state :locked do
      event :accept, :transitions_to => :accepted
      event :reject, :transitions_to => :rejected
    end
    state :accepted
    state :rejected
  end

  monetize :amount_cents, as: :amount

  def self.total(state)
    Money.new where(workflow_state: state).sum(:amount_cents)
  end

  def accept(user)
    Billing.buy_amount user: user, locking: self
  end

  def reject(user)
    Billing.free_amount user: user, locking: self
  end
end
