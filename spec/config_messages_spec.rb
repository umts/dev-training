# frozen_string_literal: true

RSpec.describe 'config/messages.yml' do
  let :file do
    Pathname.new(__dir__).join('..', 'config', 'messages.yml').expand_path
  end
  let :yaml do
    file.open do |f|
      YAML.safe_load f
    end
  end

  it 'exists' do
    expect(file).to exist
  end
  it 'is a mapping' do
    expect(yaml).to be_a Hash
  end
  it 'has string values' do
    expect(yaml.values).to all(be_a String)
  end
end
