class ApplicationMailer < ActionMailer::Base
  self.default_url_options = { host: Settings.app.host }
  default from: Settings.mailer.from

  layout 'mailer'
end
