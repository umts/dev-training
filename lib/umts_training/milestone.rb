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
    # Finds or creates the "Training exit interview" milestone on GitHub. It
    # returns (and memo-izes) the milestone resource for later use in e.g.
    # create_issues!
    def milestone
      @milestone ||= @client.milestones(@repo).find { |m| m[:title] == name } ||
                     @client.create_milestone(@repo, name)
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

    ##
    # Closes all open issues in the milestone. This will hopefully usually be
    # a no-op, but in the case where a user is re-bootrapping. It will be
    # better to not have duplicate open issues.
    def close_all_issues!
      @client.issues(@repo, milestone: milestone.number).each do |issue|
        @client.add_comment(@repo, issue.number, 'Closed: re-bootrapping')
        @client.close_issue(@repo, issue.number)
      end
    end

    private

    def name
      'Training exit interview'
    end
  end
end
