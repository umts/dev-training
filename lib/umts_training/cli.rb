module UMTSTraining
  class CLI < ::HighLine
    def initialize(messages_file)
      super($stdin, $stdout, 80)
      @message_catalog = YAML.load(messages_file)
    end

    def message(name)
      say @message_catalog.fetch(name)
    end

    def pw_ask(prompt)
      ask(prompt) { |q| q.echo = '*' }
    end
  end
end
