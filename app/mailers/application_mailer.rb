class ApplicationMailer < ActionMailer::Base
  include ActionMailer::Text
  include ActionView::Helpers::AssetUrlHelper
  include MoneyRails::ActionViewExtension

  before_action :prepare

  self.default_url_options = { host: Settings.app.host }
  self.asset_host = Settings.app.asset_host

  default from: Settings.mailer.from
  helper_method :application_title

  layout 'mailer'

  private

  def application_title
    Settings.app.name
  end

  def prepare
    @bg_image_url = image_url '/mail/bg.gif'
  end

  def t(key, options = {})
    I18n.t key, options.merge(scope: [mailer_name, action_name])
  end

  def action_mail(user)
    @user = user
    @unsubscribe_url = unsubscribe_url user.id unless instance_variable_defined?('@unsubscribe_url')

    @subject = t :subject
    @title = t :title, default: @subject
    mail to: @user.email, subject: @subject
  end
end
