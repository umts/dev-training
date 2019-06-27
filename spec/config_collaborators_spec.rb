# frozen_string_literal: true

RSpec.describe 'config/collaborators.yml' do
  let :file do
    Pathname.new(__dir__).join('..', 'config', 'collaborators.yml').expand_path
  end
  let :yaml do
    file.open do |f|
      YAML.safe_load f
    end
  end

  it 'exists' do
    expect(file).to exist
  end
  it 'is either a list or a mapping' do
    expect([Array, Hash]).to include yaml.class
  end
  it 'has teams if it is a mapping' do
    if yaml.is_a? Hash
      expect(yaml.keys).to include 'users'
      expect(yaml['teams']).to be_a Array
    end
  end
  it 'has users if it is a mapping' do
    if yaml.is_a? Hash
      expect(yaml.keys).to include 'teams'
      expect(yaml['users']).to be_a Array
    end
  end
end
