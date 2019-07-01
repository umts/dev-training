# frozen_string_literal: true

RSpec.describe 'config/qualifications.yml' do
  let :file do
    Pathname.new(__dir__).join('..', 'config', 'qualifications.yml').expand_path
  end
  let :yaml do
    file.open do |f|
      YAML.load_stream f
    end
  end

  it 'exists' do
    expect(file).to exist
  end
  it 'is a collection of documents' do
    expect(yaml).to be_a Array
  end

  describe 'each document' do
    let(:allowed_keys) { %w[title description subtasks] }

    it 'is a mapping' do
      expect(yaml).to all(be_a Hash)
    end
    it 'has only the expected keys' do
      expect(yaml.map(&:keys)).to all(satisfy do |keys|
        keys.any? && (keys - allowed_keys).empty?
      end)
    end
    it 'has a title' do
      # expect none of the titles to be_nil
      expect(yaml.map { |doc| doc['title'] }).not_to include(be nil)
    end
    it 'has `list` subtasks if it has subtasks at all' do
      expect(yaml).to all(satisfy do |document|
        document['subtasks'].nil? || document['subtasks'].is_a?(Array)
      end)
    end
  end
end
