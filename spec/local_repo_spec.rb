# frozen_string_literal: true

require 'ostruct'
RSpec.describe UMTSTraining::LocalRepo do
  let :fake_repo do
    # Git.open returns a Git::Base object
    # our initializer makes one of those and calls #remote#url on it
    fake = OpenStruct.new
    fake.remote = OpenStruct.new(url: 'git@example.com:steve/fizzbuzz.git')
    fake
  end

  it 'has accessibe instance variables' do
    allow(Git).to receive(:open).and_return(fake_repo)
    local_repo = UMTSTraining::LocalRepo.new('_')

    expect(local_repo.user).to eq('steve')
    expect(local_repo.name).to eq('fizzbuzz')
    expect(local_repo.github_name).to eq('steve/fizzbuzz')
  end
end
