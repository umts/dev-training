# frozen_string_literal: true

require 'yaml'

module UMTSTraining
  ##
  # Handles the actual creating of the milestone and its issues. Issues are
  # described in YAML and all belon to the same milestone.
  class Milestone
    include UMTSTraining::FormattingHelpers

    ##
    # `local_repo` is a UMTSTraining::LocalRepo, we mostly just need its
    # GitHub name. `client` is a UMTSTraining::Client. `yaml_file` is a file
    # formatted as described in the [DEV-README](../DEV-README_md.html).
    def initialize(local_repo, client, yaml_file)
      @yaml = yaml_file
      @client = client.client # ugh
      @repo = local_repo.github_name
    end

    ##
    # Creates the "Training exit interview" milestone on GitHub. It returns
    # (and memo-izes) the milestone resource for later use in e.g.
    # create_issues!
    def milestone
      @milestone ||= @client.create_milestone(@repo, 'Training exit interview')
    end

    ##
    # Creates the isses specified in the YAML. Each of them will be
    # associated with the "Training exit interview" milestone.
    def create_issues!
      YAML.load_stream(@yaml) do |document|
        @client.create_issue @repo,
                             document.fetch('title'),
                             format_body(document['description'],
                                         document['subtasks']),
                             milestone: milestone.number
      end
    end
  end
end
