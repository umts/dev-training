# frozen_string_literal: true

require 'ostruct'

RSpec.describe UMTSTraining::Client do
  let :client do
    instance_double(Octokit::Client)
  end
  let :cli do
    instance_double(UMTSTraining::CLI)
  end
  let :local_repo do
    OpenStruct.new(user: 'sharon', github_name: 'sharon/dev-training')
  end
  let :temp_client do
    PasswordClient.new
  end
  let :real_client do
    TokenClient.new
  end

  describe '#initialize' do
    let :bad_password_client do
      PasswordClient.new(password: 'BAD')
    end
    let :tfa_client do
      PasswordClient.new(password: 'TFA')
    end

    it 'makes a temporary client' do
      expect(cli).to receive(:pw_ask).and_return('PASSWORD')
      expect(Octokit::Client).to receive(:new)
        .with(login: 'sharon', password: 'PASSWORD')
        .and_return(temp_client)
      allow(Octokit::Client).to receive(:new)
        .with(access_token: '*')

      described_class.new(local_repo, cli)
    end

    it 'handles an incorrect password' do
      expect(cli).to receive(:pw_ask).with(/^Enter/).and_return('BAD')
      allow(Octokit::Client).to receive(:new)
        .with(login: 'sharon', password: 'BAD')
        .and_return(bad_password_client)
      allow(cli).to receive(:color).with('Password Incorrect', anything)
        .and_return(:password_incorrect)
      expect(cli).to receive(:say).with(:password_incorrect)
      expect(cli).to receive(:pw_ask).with(/^Reenter/).and_return('GOOD')
      allow(Octokit::Client).to receive(:new)
        .with(access_token: '*')

      described_class.new(local_repo, cli)
    end

    it 'handles a 2FA requirement' do
      expect(cli).to receive(:pw_ask).with(/^Enter your/).and_return('TFA')
      allow(Octokit::Client).to receive(:new)
        .with(login: 'sharon', password: 'TFA')
        .and_return(tfa_client)
      expect(cli).to receive(:pw_ask).with(/^Enter 2FA/).and_return('123456')
      allow(Octokit::Client).to receive(:new)
        .with(access_token: '*')

      described_class.new(local_repo, cli)
    end

    it 'creates and stores an auth token' do
      allow(cli).to receive(:pw_ask).and_return('PASSWORD')
      allow(Octokit::Client).to receive(:new)
        .with(login: 'sharon', password: 'PASSWORD')
        .and_return(temp_client)
      allow(Octokit::Client).to receive(:new)
        .with(access_token: '*')

      client = described_class.new(local_repo, cli)
      expect(client.auth.token).to eq '*'
    end

    it 'creates and stores a client' do
      allow(cli).to receive(:pw_ask).and_return('PASSWORD')
      allow(Octokit::Client).to receive(:new)
        .with(login: 'sharon', password: 'PASSWORD')
        .and_return(temp_client)
      allow(Octokit::Client).to receive(:new)
        .with(access_token: '*').and_return(real_client)

      client = described_class.new(local_repo, cli)
      expect(client.client).to eq real_client
    end
  end

  describe '#add_collaborators!' do
    it 'adds the correct number of collaborators' do
      allow(cli).to receive(:pw_ask).and_return('PASSWORD')
      allow(Octokit::Client).to receive(:new)
        .with(login: 'sharon', password: 'PASSWORD')
        .and_return(temp_client)
      allow(Octokit::Client).to receive(:new)
        .with(access_token: '*').and_return(real_client)

      client = described_class.new(local_repo, cli)
      expect(real_client).to receive(:add_collaborator)
        .with('sharon/dev-training', anything).exactly(4).times
      client.add_collaborators!(Array.new(4))
    end
  end

  describe '#enable_issues!' do
    it 'edits the repository to have issues' do
      allow(cli).to receive(:pw_ask).and_return('PASSWORD')
      allow(Octokit::Client).to receive(:new)
        .with(login: 'sharon', password: 'PASSWORD')
        .and_return(temp_client)
      allow(Octokit::Client).to receive(:new)
        .with(access_token: '*').and_return(real_client)

      client = described_class.new(local_repo, cli)
      expect(real_client).to receive(:edit_repository)
        .with('sharon/dev-training', {has_issues: true})
      client.enable_issues!
    end
  end
end
