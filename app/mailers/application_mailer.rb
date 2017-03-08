class ApplicationMailer < ActionMailer::Base
  # К сожалению он портит chartset и bit encoding устанавливает в 7
  # include ActionMailer::Textgiri
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

  def t(key, interpolations = {})
    # По примеру default_i18n_subject
    mailer_scope = self.class.mailer_name.tr('/', '.')
    I18n.t(key, interpolations.reverse_merge(scope: [mailer_scope, action_name], default: action_name.humanize))
  end

  def action_mail(user)
    @user = user
    @unsubscribe_url = unsubscribe_url user.id unless instance_variable_defined?('@unsubscribe_url')

    @title = t :title, default: default_i18n_subject
    mail to: @user.email
    #do |format|
      #format.text { render }
      #format.html { render }
    #end
  end
end
