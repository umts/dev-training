# frozen_string_literal: true

RSpec.describe UMTSTraining::MessageCatalog do
  let :catalog do
    described_class.new(test: 'Test Data')
  end

  it 'is like a Hash' do
    expect(catalog).to be_a(Hash)
  end

  it 'has indifferent access' do
    expect(catalog['test']).to eq('Test Data')
    expect(catalog[:test]).to eq('Test Data')
  end

  it 'has method access' do
    expect(catalog.test).to eq('Test Data')
  end

  it 'can be initialized with no arguments' do
    expect(described_class.new).to eq({})
  end

  it 'can be initialized with a Hash' do
    mc = described_class.new(foo: :bar)
    expect(mc[:foo]).to eq(:bar)
  end

  it 'can be initialized with a YAML file' do
    yaml = <<~YAML
      square: >
        A polygon with four equal sides and 4 90-degree angles
    YAML
    mc = described_class.new(StringIO.new(yaml))
    expect(mc['square']).to match(/polygon/)
  end

  it 'handles an empty YAML file gracefully' do
    mc = described_class.new(StringIO.new)
    expect(mc).to eq({})
  end
end
