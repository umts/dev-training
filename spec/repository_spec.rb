# frozen_string_literal: true

require 'ostruct'

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
    before :each do
      allow(client).to receive(:client).and_return(real_client)
    end
    let :existing_teams do
      [OpenStruct.new(name: 'Wizards', id: 2),
       OpenStruct.new(name: 'Knights', id: 12),
       OpenStruct.new(name: 'Peasants', id: 7)]
    end

    it 'doesn\'t accept a non-array or hash arguments' do
      expect { repository.add_collaborators!(:bogus) }
        .to raise_error(ArgumentError)
    end
    it 'skips trying to add the repository user thenselves' do
      expect(real_client).not_to receive(:add_collaborator)

      repository.add_collaborators!(['sharon'])
    end
    it 'adds the correct number of collaborators' do
      expect(real_client).to receive(:add_collaborator)
        .with('sharon/dev-training', anything).exactly(4).times

      repository.add_collaborators!(Array.new(4))
    end
    it 'adds users if given in a hash' do
      expect(real_client).to receive(:add_collaborator)
        .with('sharon/dev-training', anything).exactly(2).times

      repository.add_collaborators!(users: Array.new(2), teams: [])
    end
    it 'adds teams if specified' do
      expect(real_client).to receive(:org_teams)
        .with('umts').and_return(existing_teams).once
      expect(real_client).to receive(:add_team_repository)
        .with(instance_of(Integer), 'sharon/dev-training', permission: 'push')
        .twice

      repository.add_collaborators!(users: [], teams: ['Wizards', 12])
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
