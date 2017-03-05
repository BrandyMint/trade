class Order < ApplicationRecord
  include Workflow

  belongs_to :user, counter_cache: true
  belongs_to :company, counter_cache: true
  belongs_to :good

  has_one :locking, class_name: 'OpenbillLocking'

  validates :user, presence: true
  validates :company, presence: true
  validates :good, presence: true

  delegate :amount, to: :good

  delegate :locked?, to: :locking

  workflow do
    state :actual do
      event :cancel, :transitions_to => :canceled
      event :complete, :transitions_to => :completed
    end
    state :canceled
    state :completed
  end

  def complete(user)
    locking.accept! user if locking.present?
  end

  def cancel(user)
    locking.reject! user if locking.present?
  end
end
