Bugsnag.configure do |config|
  config.api_key = "0da75b4005a5275b96a760f0b503f263"

  config.app_version = AppVersion.format('%M.%m.%p')

  config.notify_release_stages = %w(production staging)
  config.send_code = true
  config.send_environment = true
end
