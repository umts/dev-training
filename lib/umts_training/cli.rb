# frozen_string_literal: true

require 'highline'
require 'umts_training/message_catalog'

module UMTSTraining
  ##
  # The `UMTSTraining::CLI` class is for interacting with the user via the
  # command-line. It is a subclass of
  # [Highline](https://www.rubydoc.info/gems/highline/HighLine) with a few
  # minor additions.
  class CLI < ::HighLine
    ##
    # Create a new cli instance. `message_file` is typically a `File`-ish
    # object that contains the YAML messages that can be displayed to the
    # user. It can, however, be anything that
    # [`MessageCatalog.new`](MessageCatalog.html#method-c-new) will accept.
    def initialize(messages_file, input: $stdin, output: $stdout)
      super(input, output, 80)
      @message_catalog = MessageCatalog.new(messages_file)
    end

    ##
    # `say` the message out of the message catalog with the name, `name`.
    #
    # Note also that this class delegates methods to said `MessageCatalog`,
    # so `CLI#my_message` is equivalent to `CLI#message(:my_message)`
    def message(name)
      say @message_catalog.fetch(name)
    end

    def method_missing(method, *args) # :nodoc:
      if @message_catalog.respond_to? method
        say @message_catalog.send(method, *args)
      else
        super
      end
    end

    ##
    # Ask for a password. This is a wrapper around HighLine#ask that
    # displays `*`s as you type.
    def pw_ask(prompt)
      ask(prompt) { |q| q.echo = '*' }
    end

    def respond_to_missing?(method_name, include_private = false) # :nodoc:
      @message_catalog.respond_to?(method_name) || super
    end
  end
end
