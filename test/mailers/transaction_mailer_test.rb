require 'test_helper'

class TransactionMailerTest < ActionMailer::TestCase
  include ActionView::Helpers::UrlHelper

  %w(income outcome).each do |action_name|
    test action_name do
      transaction = openbill_transactions :one
      user = users :one

      mail = TransactionMailer.send action_name, transaction, user
      assert_equal I18n.t("transaction_mailer.#{action_name}.subject"), mail.subject
      assert_equal [user.email], mail.to
      assert_equal [Settings.mailer.from], mail.from
    end
  end
end

