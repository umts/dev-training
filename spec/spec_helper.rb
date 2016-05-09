require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end
require 'webmock/rspec'

this_dir = File.dirname(__FILE__)
$LOAD_PATH.unshift File.expand_path(File.join(this_dir, '..', 'lib'))
require 'umts_training'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!

  config.default_formatter = 'doc' if config.files_to_run.one?
end
