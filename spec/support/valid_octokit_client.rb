# frozen_string_literal: true

RSpec.shared_context 'valid_octokit_client' do
  let :cli do
    instance_double(UMTSTraining::CLI)
  end
  let :temp_client do
    PasswordClient.new
  end
  let :real_client do
    TokenClient.new
  end

  before(:each) do
    allow(cli).to receive(:pw_ask).and_return('PASSWORD')
    allow(Octokit::Client).to receive(:new)
      .with(login: 'sharon', password: 'PASSWORD')
      .and_return(temp_client)
    allow(Octokit::Client).to receive(:new)
      .with(access_token: '*').and_return(real_client)
  end
end
