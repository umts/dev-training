# frozen_string_literal: true

source 'https://rubygems.org'
ruby IO.read(File.expand_path('.ruby-version', __dir__)).strip

gem 'git', '~> 1.4'
gem 'hashie'
gem 'highline', '~> 1.7.10'
gem 'octokit', '~> 4.9'
gem 'rake'

group :test do
  gem 'rspec'
  gem 'rubocop'
  gem 'simplecov', require: false
end

group :development do
  gem 'fancy_irb'
  gem 'pry'
  gem 'pry-byebug'
  gem 'wirb'
end
