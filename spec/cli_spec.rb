RSpec.describe UMTSTraining::CLI do
  let :cli do
    messages = <<-END
    valid_message: >
      ABCD
    END
    UMTSTraining::CLI.new(StringIO.new(messages))
  end

  it 'is attached to stdin/stdout' do
    expect(cli.instance_variable_get(:@input)).to be($stdin)
    expect(cli.instance_variable_get(:@output)).to be($stdout)
  end

  describe '#message' do
    it 'outputs a message from the catalog' do
      expect($stdout).to receive(:puts).with("ABCD\n")
      cli.message 'valid_message'
    end
    it 'raises an exception on an unknown message' do
      expect { cli.message 'invalid_message' }.to raise_error(KeyError)
    end
  end
end
