# frozen_string_literal: true

require 'hashie'

module UMTSTraining
  class MessageCatalog < ::Hash
    include Hashie::Extensions::IndifferentAccess
    include Hashie::Extensions::MergeInitializer
    include Hashie::Extensions::MethodAccess

    def initialize(catalog = {}, default = nil, &block)
      catalog = YAML.safe_load(catalog) || {} if catalog.respond_to? :read
      super(catalog, default, &block)
    end
  end
end
