# config valid only for current version of Capistrano
lock '3.7.2'

set :application, 'online-prodaja.club'
set :repo_url, 'git@github.com:BrandyMint/trade.git'

set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

#
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

# Default value for keep_releases is 5
# set :keep_releases, 5
desc 'Notify http://bugsnag.com'

namespace :deploy do
  task :notify_bugsnag do
    run_locally do
      execute :rake, 'bugsnag:deploy BUGSNAG_API_KEY=0da75b4005a5275b96a760f0b503f263'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:sidekiq), in: :sequence, wait: 5 do
      execute "/etc/init.d/sidekiq-#{fetch(:application)} restart"
    end
  end

  after :finishing, 'notify_bugsnag'
  after :publishing, :restart
end
