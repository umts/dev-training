# frozen_string_literal: true

def optional_gem_task(*requires)
  requires.each do |req|
    require req
  end
  yield
rescue LoadError
  gemname = req.split('/').first.capitalize
  puts ">>>>> #{gemname} gem not loaded; ommitting task" unless ENV['CI']
end

optional_gem_task('rdoc/task') do
  RDoc::Task.new do |rdoc|
    rdoc.main = 'DEV-README.md'
    rdoc.markup = 'markdown'
    rdoc.rdoc_files.include('DEV-README.md', 'lib')
    rdoc.rdoc_dir = 'docs'
  end
end

optional_gem_task('rspec/core/rake_task') do
  RSpec::Core::RakeTask.new(:spec) do |rspec|
    next unless ENV['CI']

    rspec.rspec_opts = [
      '--format progress',
      '--fail-fast',
      '--no-profile'
    ]
  end
end

optional_gem_task('rubocop/rake_task') do
  RuboCop::RakeTask.new do |rubocop|
    next unless ENV['CI']

    rubocop.options = [
      ['--fail-level', 'W'],
      '--display-only-fail-level-offenses',
      '--fail-fast'
    ]
    rubocop.formatters = ['simple']
  end
end

optional_gem_task('rspec/core/rake_task', 'rubocop/rake_task') do
  desc 'Run all tests and linters.'
  task :default do
    Rake::Task['rubocop'].invoke
    Rake::Task['spec'].invoke
  end
end
