class OpenbillLocking < ApplicationRecord
  extend ActiveSupport::Concern
  include Workflow

  belongs_to :seller, class_name: 'Company'
  belongs_to :buyer, class_name: 'Company'
  belongs_to :good

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

  def accept(admin)
    # TODO update admin
    Billing.buy_amount self
  end

  def reject(admin)
    Billing.free_amount self
  end
end
