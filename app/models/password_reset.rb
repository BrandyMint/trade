class PasswordReset
  include ActiveModel::Model
  attr_accessor :email

  validates :email, presence: true, email: true

  # validate :user_presence

  private

  def user_presence
    errors.add :email, 'Нет пользователя с таким емайлом' unless User.find_by_email(email).present?
  end
end
