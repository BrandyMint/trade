require 'test_helper'

class CompanyMailerTest < ActionMailer::TestCase
  include ActionView::Helpers::UrlHelper

  %w(accepted_email rejected_email).each do |action_name|
    test action_name do
      company = companies :one
      user = company.user
      mail = CompanyMailer.send action_name, company
      assert_equal I18n.t("company_mailer.#{action_name}.subject"), mail.subject
      assert_equal [user.email], mail.to
      assert_equal [Settings.mailer.from], mail.from
    end
  end
end
