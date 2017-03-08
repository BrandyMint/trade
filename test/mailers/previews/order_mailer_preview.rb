# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class OrderMailerPreview < ActionMailer::Preview

  def created
    OrderMailer.created Order.first, User.first
  end

end
