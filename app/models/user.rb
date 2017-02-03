class User < ApplicationRecord
  extend Enumerize
  authenticates_with_sorcery!

  has_many :companies

  validates :name,                    presence: true
  validates :phone,                   presence: true
  validates :password,                presence: true, confirmation: true, length: { minimum: 3}
  validates :email,                   presence: true, uniqueness: true, email: true
  validates :password_confirmation,   presence: true

  enumerize :role,
    in: %w(user manager superadmin),
    predicates: true,
    scope: true,
    default: 'user'

  def is_admin?
    manager? || superadmin?
  end

  def to_s
    name.presence || email
  end

  def to_label
    to_s
  end
end
