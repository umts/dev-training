# frozen_string_literal: true

require 'pathname'
unless ENV['CI']
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
  end
end

lib_dir = Pathname(__dir__).join('..', 'lib').expand_path
$LOAD_PATH.unshift lib_dir
require 'umts_training'

Pathname(__dir__).join('support').expand_path.glob('**/*.rb').each do |file|
  require file
end

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.order = :random
  Kernel.srand config.seed

  config.disable_monkey_patching!

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
