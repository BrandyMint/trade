class User < ApplicationRecord
  extend Enumerize
  include PhoneNormalizer
  authenticates_with_sorcery!

  has_many :companies
  has_many :accounts, through: :companies
  has_many :goods, through: :companies
  has_many :orders

  has_many :income_orders, through: :goods, source: :good

  scope :users, -> { with_role  :user }

  before_validation :clean_phone
  before_save :clean_phone
  validates :name,                    presence: true
  validates :phone,                   presence: true, phone: true, uniqueness: true
  validates :email,                   presence: true, uniqueness: true, email: true

  validates :password_confirmation,   presence: true, if: :new_record?
  validates :password,                presence: true, confirmation: true, length: { minimum: 3}, if: :new_record?

  enumerize :role,
    in: %w(user manager superadmin),
    predicates: true,
    scope: true,
    default: 'user'

  def shown_banner(id)
    update_column :shown_banners, shown_banners + [id]
  end

  def is_admin?
    manager? || superadmin?
  end

  def to_s
    name.presence || email
  end

  def to_label
    to_s
  end

  def transactions
    ids = companies.pluck(:account_id)
    OpenbillTransaction.where(from_account_id: ids).or(OpenbillTransaction.where(to_account_id: ids))
  end

  private

  def clean_phone
    self.phone = normalize_phone self.phone if self.phone.present?
  end
end
