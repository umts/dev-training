# frozen_string_literal: true

require 'yaml'

module UMTSTraining
  class Milestone
    include UMTSTraining::FormattingHelpers

    def initialize(local_repo, client, yaml_file)
      @yaml = yaml_file
      @client = client.client # ugh
      @repo = local_repo.github_name
    end

    def create!
      @milestone ||= @client.create_milestone(@repo, 'Training exit interview')
    end

    def create_issues!
      YAML.load_stream(@yaml) do |document|
        @client.create_issue @repo,
                             document.fetch('title'),
                             format_body(document['description'],
                                         document['subtasks']),
                             milestone: @milestone.number
      end
    end
  end
end
