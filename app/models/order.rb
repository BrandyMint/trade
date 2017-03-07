class Order < ApplicationRecord
  include Workflow

  # Покупатель
  belongs_to :user, counter_cache: true
  # Компания, на которую покупают
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

  after_create do
    OrderMailer.created(self, seller_user).deliver_later!
  end

  def seller_user
    good.user
  end

  def buyer_user
    user
  end

  # Публичный номер заказа
  def number
    id.to_s
  end

  def complete(user)
    locking.accept! user if locking.present?

    OrderMailer.complete(self, seller_user).deliver_later!
    OrderMailer.complete(self, buyer_user).deliver_later!
  end

  def cancel(user)
    locking.reject! user if locking.present?

    OrderMailer.cancel(self, seller_user).deliver_later!
    OrderMailer.cancel(self, buyer_user).deliver_later!
  end
end
