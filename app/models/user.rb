class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :companies

  validates :password,                presence: true, confirmation: true, length: { minimum: 3}
  validates :email,                   presence: true, uniqueness: true
  validates :password_confirmation,   presence: true

  def to_s
    name.presence || email
  end
end
