source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'jbuilder', '~> 2.7'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.0.2', '>= 6.0.2.2'
gem 'rails-i18n'
gem 'sass-rails', '>= 6'
gem 'mysql2', '>= 0.5.3'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'
gem 'tzinfo-data'
gem 'devise'
gem 'cancancan'
gem 'city-state'
gem 'devise_invitable', '~> 2.0.0'
gem 'rubyzip'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 4-0-maintenance'
  gem 'capybara', '>= 2.15'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'sqlite3', '1.4.2'
  gem 'webdrivers'
  gem 'capybara-selenium'
  gem 'rails-controller-testing'
  gem 'simplecov'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rack-mini-profiler', '~> 2.0', '>= 2.0.1'
end
