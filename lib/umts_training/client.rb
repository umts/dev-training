# frozen_string_literal: true

require 'octokit'

module UMTSTraining
  class Client
    attr_reader :auth, :client

    def initialize(local_repo, cli)
      password = cli.pw_ask 'Enter your GitHub pasword: '
      temp_client = Octokit::Client.new(
        login: local_repo.user,
        password: password
      )

      @auth = make_auth(temp_client, cli)
      @client = Octokit::Client.new(access_token: auth.token)
      @repo = local_repo
    end

    def add_collaborators!(collaborators)
      collaborators.each do |collaborator|
        next if collaborator == @repo.user
        @client.add_collaborator(@repo.github_name, collaborator)
      end
    end

    def enable_issues!
      @client.edit_repository(@repo.github_name, has_issues: true)
    end

    private

    def make_auth(temp_client, cli, tfa = nil)
      temp_client.create_authorization(auth_settings(tfa))
    rescue Octokit::Unauthorized
      cli.say cli.color 'Password Incorrect', :red
      temp_client.password = cli.pw_ask 'Enter your GitHub password: '
      retry
    rescue Octokit::OneTimePasswordRequired
      tfa = cli.pw_ask 'Enter 2FA code: '
      make_auth(temp_client, cli, tfa)
    end

    def auth_settings(tfa = nil)
      {}.tap do |h|
        h[:scopes] = %w[user repo]
        h[:note] = 'UMTS Programmer Training'
        h[:headers] = { 'X-Github-OTP' => tfa } if tfa
      end
    end
  end
end
