Rails.application.configure do
  if Secrets.smtp_settings.is_a? Hash
    config.action_mailer.smtp_settings = Secrets.smtp_settings.symbolize_keys
  end
end
