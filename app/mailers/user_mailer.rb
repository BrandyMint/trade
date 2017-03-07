class UserMailer < ApplicationMailer
  def reset_password_email(user)
    @url  = edit_password_reset_url(user.reset_password_token)

    # Убираем ссылку рассылки
    @unsubscribe_url = nil

    action_mail user
  end
end
