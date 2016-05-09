require 'ostruct'
require 'support/fake_github'

RSpec.describe UMTSTraining::Client do
  let :cli do
    instance_double(UMTSTraining::CLI)
  end
  let :client do
    local_repo = OpenStruct.new(user: 'ben', github_name: 'ben/fuggles')
    UMTSTraining::Client.new(local_repo, cli)
  end

  before :each do
    stub_request(:any, /api.github.com/).to_rack(FakeGitHub)
  end
  describe '#initialize' do
    it 'makes a temporary client' do
      allow(cli).to receive(:pw_ask).and_return('password')

      expect(Octokit::Client).to receive(:new)
        .with(hash_including(login: 'ben', password: 'password'))
        .and_return(Octokit::Client.new(login: 'ben', password: 'password'))
        .once

      allow(Octokit::Client).to receive(:new)
        .with(hash_including(
          access_token: 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeef'
        ))

      client
    end
    it 'handles an incorrect password' do
      allow(cli).to receive(:color)
      allow(cli).to receive(:say)
      expect(cli).to receive(:pw_ask).and_return('bogus', 'password').twice
      client
    end
    it 'handles a 2FA requirement'
    it 'creates and stores an auth token'
    it 'creates and stores a client'
  end

  describe '#add_collaborators!' do
    it 'adds the correct number of collaborators'
  end
end
