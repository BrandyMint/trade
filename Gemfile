source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
gem 'capistrano-rails', group: :development

gem 'openbill-ruby', github: 'openbill-service/openbill-ruby'
gem 'pundit'
gem 'kaminari'
gem 'bootstrap-kaminari-views', git: 'https://github.com/klacointe/bootstrap-kaminari-views', branch: 'bootstrap4'
gem 'slim-rails'
gem 'bootstrap', '~> 4.0.0.alpha6'
# gem 'bugsnag'
gem 'virtus'
gem 'hashie'
gem 'sorcery'
gem 'ancestry'

gem 'ranked-model'
gem 'enumerize'

gem 'simple-navigation', git: 'git://github.com/andi/simple-navigation.git'
gem 'simple-navigation-bootstrap'

gem 'font-awesome-rails'
gem 'simple_form', git: 'git://github.com/plataformatec/simple_form.git'

gem 'active_link_to'

gem 'cocoon'

gem 'semver2'
# gem 'gravatarify'
# gem 'file_validators'
gem 'validates'
# gem 'valid_email', require: 'valid_email/validate_email'

gem 'pg_search'
gem 'responders'
gem 'mini_magick'
gem 'carrierwave'

gem 'dropzonejs-rails'
source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
  gem 'rails-assets-better-dom'
  gem 'rails-assets-better-i18n-plugin'
  gem 'rails-assets-better-popover-plugin'
  gem 'rails-assets-better-form-validation'
end

# Use jquery as the JavaScript library
gem 'nprogress-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'pry-rails'
  gem 'pry-theme'

  gem 'pry-pretty-numeric'
  # gem 'pry-highlight'
  # step, next, finish, continue, break
  gem 'pry-nav'

  gem 'pry-doc'
  gem 'pry-docmore'

  # Добавляет show-stack
  gem 'pry-stack_explorer'

  gem 'guard'
  gem 'guard-minitest'
  gem 'guard-ctags-bundler'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
