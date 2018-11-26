# frozen_string_literal: true

require 'hashie'
require 'yaml'

module UMTSTraining
  ##
  # Essentially a hash with two additions:
  #
  # 1. It includes the [IndifferentAccess][1], [MergeInitializer][2], and
  #    [MethodAccess][3] mixins from Hashie.
  # 2. It can also be initialized with a `File`-ish object that contains
  #    a YAML mapping.
  #
  # [1]: https://www.rubydoc.info/github/intridea/hashie#IndifferentAccess
  # [2]: https://www.rubydoc.info/github/intridea/hashie#MergeInitializer
  # [3]: https://www.rubydoc.info/github/intridea/hashie#MethodAccess
  class MessageCatalog < ::Hash
    include Hashie::Extensions::IndifferentAccess
    include Hashie::Extensions::MergeInitializer
    include Hashie::Extensions::MethodAccess

    ##
    # ```
    # UMTSTraining::MessageCatalog.new
    # #=> {}
    # UMTSTraining::MessageCatalog.new(a: 1, b: 2)
    # #=> {"a" => 1, "b" => 2}
    # UMTSTraining::MessageCatalog.new(File.open('some.yml'))
    # #=> {"key_from_yaml_file" => "value_from_yaml_file}
    # ```
    #
    # The `default` and `&block` arguments are passed along to `Hash.new` if
    # specified.
    def initialize(catalog = {}, default = nil, &block)
      catalog = YAML.safe_load(catalog) || {} if catalog.respond_to? :read
      super(catalog, default, &block)
    end
  end
end
