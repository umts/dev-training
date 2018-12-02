# frozen_string_literal: true

RSpec.describe UMTSTraining::Repository do
  let :client do
    instance_double(UMTSTraining::Client)
  end
  let :local_repo do
    OpenStruct.new(user: 'sharon', github_name: 'sharon/dev-training')
  end
  let :repository do
    described_class.new(local_repo, client)
  end

  describe '#add_collaborators!' do
    include_context 'valid_octokit_client'
    before(:each) do
      allow(client).to receive(:client).and_return(real_client)
    end

    it 'adds the correct number of collaborators' do
      expect(real_client).to receive(:add_collaborator)
        .with('sharon/dev-training', anything).exactly(4).times

      repository.add_collaborators!(Array.new(4))
    end
  end

  describe '#enable_issues!' do
    include_context 'valid_octokit_client'
    before(:each) do
      allow(client).to receive(:client).and_return(real_client)
    end

    it 'edits the repository to have issues' do
      expect(real_client).to receive(:edit_repository)
        .with('sharon/dev-training', has_issues: true)

      repository.enable_issues!
    end
  end
end
