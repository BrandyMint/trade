class Settings < Settingslogic
  source "#{Rails.root}/config/settings.local.yml" if File.exist? "#{Rails.root}/config/settings.local.yml"
  source "#{Rails.root}/config/settings.yml"
  namespace Rails.env

  suppress_errors Rails.env.production?

  # ActionDispatch::Http::URL.tld_length = Settings.app.tld_length

  def root
    Pathname.new(super.presence || Rails.root)
  end
end
