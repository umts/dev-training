# frozen_string_literal: true

RSpec.describe UMTSTraining::CLI do
  let :cli do
    messages = StringIO.new(<<~YAML)
      valid_message: >
        ABCD
    YAML
    UMTSTraining::CLI.new(messages)
  end

  it 'is attached to stdin/stdout by default' do
    expect(cli.instance_variable_get(:@input)).to be($stdin)
    expect(cli.instance_variable_get(:@output)).to be($stdout)
  end

  describe '#message' do
    it 'outputs a string-keyed message from the catalog' do
      expect { cli.message 'valid_message' }.to output("ABCD\n").to_stdout
    end
    it 'outputs a symbol-keyed message from the catalog' do
      expect { cli.message :valid_message }.to output("ABCD\n").to_stdout
    end
    it 'raises an exception on an unknown message' do
      expect { cli.message 'invalid_message' }.to raise_error(KeyError)
    end
  end

  describe '#method_missing' do
    it 'delegates methods to the message catalog if it can' do
      expect { cli.valid_message }.to output("ABCD\n").to_stdout
    end
    it 'raises a no method error if it cannot' do
      expect { cli.invalid_message }.to raise_error(NoMethodError)
        .with_message(/#{described_class}/)
    end
  end

  describe '#pw_ask' do
    before :each do
      @pw = 'PaSsWoRd'
    end

    let :password_gatherer do
      password = StringIO.new(@pw)
      UMTSTraining::CLI.new(StringIO.new, input: password)
    end

    it 'collects a password' do
      expect(password_gatherer.pw_ask('Password?')).to eq(@pw)
    end

    it "outputs *'s to stdout" do
      stars = ('*' * @pw.length) + "\r\n"
      expect { password_gatherer.pw_ask('') }.to output(stars).to_stdout
    end
  end
end
