class UserSession
  include ActiveModel::Model
  attr_accessor :email, :password, :remember

  validates :email, presence: true
  validates :password, presence: true
end
