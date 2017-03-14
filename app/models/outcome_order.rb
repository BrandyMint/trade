class OutcomeOrder < ApplicationRecord
  include Workflow
  MAX_OUTCOME_AMOUNT = 10_000_000

  belongs_to :user
  belongs_to :moderator, class_name: 'User'
  belongs_to :company
  belongs_to :requisite
  # belongs_to :transaction, class_name: 'OpenbillTransaction', foreign_key: :transaction_uuid
  belongs_to :manager, class_name: 'User'

  has_one :account, through: :company
  has_many :transactions, class_name: 'OpenbillTransaction'

  scope :drafts, -> { where workflow_state: :draft }
  scope :ordered, -> { order 'id desc' }

  monetize :amount_cents, as: :amount

  validates :requisite, presence: true
  validates :amount, presence: true, money: { greater_than: 0, less_than: MAX_OUTCOME_AMOUNT }

  validate :account_amount, on: :create

  accepts_nested_attributes_for :requisite

  workflow do
    state :draft do
      event :accept, :transitions_to => :accepted
      event :reject, :transitions_to => :rejected
    end
    state :accepted
    state :rejected
  end

  # workflow не успевает устеновить state
  # validates :reject_message, presence: true, if: :rejected?

  def accept(moderator)
    update_attributes!(
      moderator: moderator
    )
  end

  def reject(moderator)
    update_attributes!(
      moderator: moderator
    )
  end

  def enough_amount?
    amount.zero? || amount <= account.amount
  end

  private

  def account_amount
    return if enough_amount?
    errors.add :amount, "Суммы на счете не достаточно (#{account.amount.format} < #{amount.format})"
  end
end
