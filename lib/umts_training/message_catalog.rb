# frozen_string_literal: true

require 'hashie'

module UMTSTraining
  class MessageCatalog < ::Hash
    include Hashie::Extensions::IndifferentAccess
    include Hashie::Extensions::MergeInitializer
    include Hashie::Extensions::MethodAccess

    def initialize(catalog = {}, default = nil, &block)
      if catalog.respond_to? :read
        catalog = YAML.safe_load(catalog) || {}
      end
      super(catalog, default, &block)
    end
  end
end
