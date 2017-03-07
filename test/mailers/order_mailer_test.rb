require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase
  include ActionView::Helpers::UrlHelper

  %w(created complete cancel).each do |action_name|
    test action_name do
      order = orders :one
      user = order.user
      mail = OrderMailer.send action_name, order, user
      assert_equal I18n.t("order_mailer.#{action_name}.subject"), mail.subject
      assert_equal [user.email], mail.to
      assert_equal [Settings.mailer.from], mail.from
      assert_match Rails.application.routes.url_helpers.order_path(order), mail.body.encoded
    end
  end
end
