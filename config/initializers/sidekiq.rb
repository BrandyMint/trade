# schedule_file = "config/schedule.yml"

Sidekiq.default_worker_options = { 'backtrace' => true }

if Rails.env.production?
  Sidekiq.configure_server do |config|
    config.redis = { :url => 'redis://localhost:6379/0', :namespace => :online }
    #Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file) if File.exists?(schedule_file)
  end

  Sidekiq.configure_client do |config|
    config.redis = { :url => 'redis://localhost:6379/0', :namespace => :online }
  end
else
  require 'sidekiq/testing/inline'
  Sidekiq::Testing.inline!
end
