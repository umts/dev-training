# frozen_string_literal: true

RSpec.describe UMTSTraining::Client do
  describe '#initialize' do
    it 'makes a temporary client'
    it 'handles an incorrect password'
    it 'handles a 2FA requirement'
    it 'creates and stores an auth token'
    it 'creates and stores a client'
  end

  describe '#add_collaborators!' do
    it 'adds the correct number of collaborators'
  end
end
