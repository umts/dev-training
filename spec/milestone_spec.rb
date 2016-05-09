require 'ostruct'

RSpec.describe UMTSTraining::Milestone do
  let :client do
    instance_double(Octokit::Client)
  end
  let :milestone do
    # Like a UMTSTraining::LocalRepo :
    repo = OpenStruct.new(github_name: 'judy/harfbang') 
    # Like a UMTSTraining::Client :
    uclient = OpenStruct.new(client: client)
    yaml = <<-END.gsub(/^\s{4}/, '')
    ---
    title: TEST-TITLE
    description: >
      TEST-DESCRIPTION
    ---
    title: WITHOUT-DESCRIPTION
    ---
    title: WITH-SUBTASKS
    description: >
    subtasks:
      - FIRST-SUBTASK
      - SECOND-SUBTASK
    END
    yaml_file = StringIO.new yaml
    UMTSTraining::Milestone.new(repo, uclient, yaml_file)
  end

  describe '#create!' do
    it 'tells the client to create a milestone' do
      expect(client).to receive(:create_milestone)
        .with('judy/harfbang', 'Training exit interview')
      milestone.create!
    end

    it 'does not re-create a milestone if already initialized' do
      expect(client).to receive(:create_milestone)
        .with('judy/harfbang', 'Training exit interview')
        .and_return('ANYTHING').once

      first_milestone = milestone.create!
      second_milestone = milestone.create!
      expect(first_milestone).to be(second_milestone)
    end
  end

  describe '#create_issues!' do
    before :each do
      @ms_num = 1

      yaml_file = milestone.instance_variable_get(:@yaml)
      @document_count = YAML.load_stream(yaml_file).count
      yaml_file.rewind

      allow(client).to receive(:create_milestone)
        .and_return(OpenStruct.new(number: @ms_num))
      milestone.create!
    end
    it 'creates one issue for each YAML doc' do
      expect(client).to receive(:create_issue).exactly(@document_count).times
      milestone.create_issues!
    end
    it 'uses the repository name' do
      expect(client).to receive(:create_issue)
        .with('judy/harfbang', any_args).exactly(@document_count).times
      milestone.create_issues!
    end
    it 'uses the milestone number' do
      expect(client).to receive(:create_issue)
        .with(anything, anything, anything, hash_including(milestone: @ms_num))
        .exactly(@document_count).times
      milestone.create_issues!
    end
    it 'uses the title for an issue' do
      allow(client).to receive(:create_issue)
      expect(client).to receive(:create_issue)
        .with(anything, /TEST-TITLE/, any_args).once
      milestone.create_issues!
    end
    it 'includes the description if provided' do
      allow(client).to receive(:create_issue)
      expect(client).to receive(:create_issue)
        .with(anything, anything, /TEST-DESCRIPTION/, anything).once
      milestone.create_issues!
    end
    it 'handles a missing description' do
      allow(client).to receive(:create_issue)
      expect(client).to receive(:create_issue)
        .with(anything, anything, nil, anything).once
      milestone.create_issues!
    end
    it 'has a tesk list if there are sub-tasks' do
      allow(client).to receive(:create_issue)
      expect(client).to receive(:create_issue)
        .with(anything, anything, /\* \[ \] /, anything).once
      milestone.create_issues!
    end
  end
end
