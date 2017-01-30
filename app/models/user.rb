class User < ApplicationRecord
  authenticates_with_sorcery!

  has_one :company

  validates :password,                presence: true, confirmation: true, length: { minimum: 3}
  validates :email,                   presence: true, uniqueness: true, email: true
  validates :password_confirmation,   presence: true

  def to_s
    name.presence || email
  end
end
