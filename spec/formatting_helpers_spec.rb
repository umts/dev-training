# frozen_string_literal: true

RSpec.describe UMTSTraining::FormattingHelpers do
  let :formatter do
    Class.new do
      include UMTSTraining::FormattingHelpers
    end.new
  end
  let :body do
    <<~BODY
      This is an example issue body.

      It has two paragraphs.
    BODY
  end

  describe '.format_body' do
    it 'passes along the body with no subtasks' do
      expect(described_class.format_body(body)).to eq body
    end
    it 'appends a tasklist' do
      body_with_tasklist = described_class.format_body(body, [1, 2])
      expect(body_with_tasklist).to include(body)
      expect(body_with_tasklist.scan(/\* \[ \]/).count).to be 2
    end
    it 'permits an empty description without subtasks' do
      expect(described_class.format_body(nil)).to be_nil
    end
    it 'permits an empty description with subtasks' do
      expect { described_class.format_body(nil, [1]) }.not_to raise_error
      expect(described_class.format_body(nil, [1]).lines.count).to be 1
    end
    it 'is a private method when included' do
      expect(formatter.methods).not_to include(:format_body)
      expect(formatter.private_methods).to include(:format_body)
    end
  end

  describe '.format_checklist' do
    it 'makes a tasklist out of an array of tasks' do
      checklist = described_class.format_checklist([1, 2])
      expect(checklist.lines.count).to be 2
      expect(checklist.lines).to all include('* [ ]')
    end
    it 'is a private method when included' do
      expect(formatter.methods).not_to include(:format_checklist)
      expect(formatter.private_methods).to include(:format_checklist)
    end
  end
end
