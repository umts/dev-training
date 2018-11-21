# frozen_string_literal: true

require 'highline'
require 'umts_training/message_catalog'

module UMTSTraining
  class CLI < ::HighLine
    def initialize(messages_file, input: $stdin, output: $stdout)
      super(input, output, 80)
      @message_catalog = MessageCatalog.new(messages_file)
    end

    def message(name)
      say @message_catalog.fetch(name)
    end

    def method_missing(method, *args)
      if @message_catalog.respond_to? method
        say @message_catalog.send(method, *args)
      else
        super
      end
    end

    def pw_ask(prompt)
      ask(prompt) { |q| q.echo = '*' }
    end
  end
end
