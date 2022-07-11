# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'
gem 'bootsnap', require: false
gem 'cssbundling-rails'
gem 'html2slim'
gem 'jbuilder'
gem 'jsbundling-rails'
gem 'meta-tags'
gem 'pg'
gem 'puma'
gem 'rails', '7.0.2.4'
gem 'slim-rails'
gem 'sprockets-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rubocop', require: false
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'rspec-debug'
  gem 'rspec-rails'
  gem 'selenium-webdriver', '4.2.0'
  gem 'webdrivers'
end

group :production do
  gem 'aws-sdk-s3', require: false
end
