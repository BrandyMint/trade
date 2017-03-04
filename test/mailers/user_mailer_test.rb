require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "reset_password_email" do
    user = users :one
    mail = UserMailer.reset_password_email user
    assert_equal I18n.t('user_mailer.reset_password_email.subject'), mail.subject
    assert_equal [user.email], mail.to
    assert_equal [Settings.mailer.from], mail.from
    assert_match user.reset_password_token, mail.body.encoded
  end
end
