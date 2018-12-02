# frozen_string_literal: true

require 'ostruct'

RSpec.describe UMTSTraining::Client do
  let :cli do
    instance_double(UMTSTraining::CLI)
  end
  let :local_repo do
    OpenStruct.new(user: 'sharon', github_name: 'sharon/dev-training')
  end
  let :temp_client do
    PasswordClient.new
  end

  describe '#initialize' do
    let :bad_password_client do
      PasswordClient.new(password: 'BAD')
    end
    let :tfa_client do
      PasswordClient.new(password: 'TFA')
    end
    let :existing_auths do
      [{ note: 'UMTS Programmer Training', id: 42 }]
    end
    let :call do
      described_class.new(local_repo, cli)
    end

    it 'makes a temporary client' do
      expect(cli).to receive(:pw_ask).and_return('PASSWORD')
      expect(Octokit::Client).to receive(:new)
        .with(login: 'sharon', password: 'PASSWORD')
        .and_return(temp_client)
      allow(Octokit::Client).to receive(:new)
        .with(access_token: '*')

      call
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

      call
    end

    it 'handles a 2FA requirement' do
      expect(cli).to receive(:pw_ask).with(/^Enter your/).and_return('TFA')
      allow(Octokit::Client).to receive(:new)
        .with(login: 'sharon', password: 'TFA')
        .and_return(tfa_client)
      expect(cli).to receive(:pw_ask).with(/^Enter 2FA/).and_return('123456')
      allow(Octokit::Client).to receive(:new)
        .with(access_token: '*')

      call
    end

    it 'deletes an existing authorization if it exists' do
      allow(cli).to receive(:pw_ask).and_return('GOOD')
      allow(Octokit::Client).to receive(:new)
        .with(login: 'sharon', password: 'GOOD')
        .and_return(temp_client)
      expect(temp_client).to receive(:authorizations)
        .and_return(existing_auths)
      expect(temp_client).to receive(:delete_authorization)
        .with(42, anything)
      allow(Octokit::Client).to receive(:new)
        .with(access_token: '*')

      call
    end

    context 'with a valid client' do
      include_context 'valid_octokit_client'
      let :client do
        described_class.new(local_repo, cli)
      end

      it 'creates and stores an auth token' do
        expect(client.auth.token).to eq '*'
      end

      it 'creates and stores a client' do
        expect(client.client).to eq real_client
      end
    end
  end
end
