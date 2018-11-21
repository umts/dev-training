# frozen_string_literal: true

RSpec.describe UMTSTraining do
  describe '.collaborators' do
    it 'is an array of strings valid as GitHub usernames' do
      expect(UMTSTraining.collaborators).to all(match(/^[a-zA-Z0-9-]+$/))
    end
  end
end
