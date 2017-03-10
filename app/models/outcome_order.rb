class OutcomeOrder < ApplicationRecord
  include Workflow

  belongs_to :user
  belongs_to :company
  belongs_to :requisite
  # belongs_to :transaction, class_name: 'OpenbillTransaction', foreign_key: :transaction_uuid
  belongs_to :manager, class_name: 'User'

  has_one :account, through: :company

  monetize :amount_cents, as: :amount

  validates :amount, presence: true
  validates :requisite, presence: true
  validates :amount, money: { greater_than: 0 }

  validate :account_amount

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

  private

  def account_amount
    return unless amount > account.amount
    errors.add :amount, "Суммы на счете не достаточно (#{account.amount.format} < #{amount.format})"
  end
end
