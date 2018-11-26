# frozen_string_literal: true

require 'git'
require 'pathname'
require 'tmpdir'

RSpec.describe UMTSTraining::LocalRepo do
  let :fake_repo do
    directory = Pathname(Dir.mktmpdir)
    git = Git.init directory.to_path
    git.add_remote 'origin',
                   'git@example.com:steve/fizzbuzz.git',
                   fetch: false
    directory
  end

  after(:each) do
    fake_repo.rmtree
  end

  it 'has accessibe instance variables' do
    local_repo = UMTSTraining::LocalRepo.new(fake_repo)

    expect(local_repo.user).to eq('steve')
    expect(local_repo.name).to eq('fizzbuzz')
    expect(local_repo.github_name).to eq('steve/fizzbuzz')
  end
end
