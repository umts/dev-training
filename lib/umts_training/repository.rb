# frozen_string_literal: true

require 'hashie'

module UMTSTraining
  ##
  # Represents the remote repository and handles the interaction with GitHub
  # that isn't covered by UMTSTraining::Milestone.
  class Repository
    ##
    # `local_repo` is a UMTSTraining::LocalRepo -- used for getting the remote
    # repository name -- `client` is a UMTSTraining::Client for interacting with
    # the Github API.
    def initialize(local_repo, client)
      @client = client.client # ugh
      @repo = local_repo
    end

    ##
    # Adds collaborators to the GitHub remote repository. `collaborators` may
    # either be an array of GitHub user names _or_ a hash with a `:users`
    # (or `"users"`) key -- which maps to an array of GitHub user names -- and
    # a `:teams` (or `"teams"`) key -- # which maps to an array of team names
    # or team ids.
    def add_collaborators!(collaborators)
      case collaborators
      when Array
        add_user_collaborators collaborators
      when Hash
        c = Hashie::Mash.new collaborators
        [add_user_collaborators(c.fetch(:users)),
         add_team_collaborators(c.fetch(:teams))].all?
      else
        raise ArgumentError, 'must be an Array or a Hash'
      end
    end

    ##
    # Enables issues on the GitHub repository. Issues are disabled on the
    # private fork of this repository (because they belong in the public
    # repo), but that means that the trainee's fork also has issues disabled
    # which is counter to the purpose of this application.
    def enable_issues!
      @client.edit_repository(@repo.github_name, has_issues: true)
    end

    private

    def add_team_collaborators(teams)
      teams.map do |team|
        team_id = if team.is_a? Integer
                    team
                  else
                    @client.org_teams('umts').find { |t| t.name == team }&.id
                  end
        @client.add_team_repository(team_id,
                                    @repo.github_name,
                                    permission: 'push')
      end.all?
    end

    def add_user_collaborators(users)
      users.map do |user|
        next if user == @repo.user

        @client.add_collaborator(@repo.github_name, user)
      end.all?
    end
  end
end
