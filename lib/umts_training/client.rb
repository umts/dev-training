# frozen_string_literal: true

require 'octokit'

module UMTSTraining
  ##
  # This class if for doing all of the base interaction with GitHub. It is
  # responsible for getting authorization and doing some basic repository
  # setup.
  class Client
    # The resource for the client's
    # [authorization](http://octokit.github.io/octokit.rb/Octokit/Client/Authorizations.html)
    attr_reader :auth
    # The actual OctoKit [client](http://octokit.github.io/octokit.rb/Octokit/Client.html)
    attr_reader :client

    ##
    # Makes the authorization(s) required on initialization. `local_repo` is a
    # UMTSTraining::LocalRepo -- needed for determining the GitHub user and
    # remote -- and `cli` is a UMTSTraining::CLI -- used for getting passwords
    # from the user.
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

    ##
    # Adds each of the `collaborators` specified (as an `Array` of `String`s)
    # to the GitHub remote repository.
    def add_collaborators!(collaborators)
      collaborators.each do |collaborator|
        next if collaborator == @repo.user

        @client.add_collaborator(@repo.github_name, collaborator)
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

    def make_auth(temp_client, cli, tfa = nil)
      remove_old_auth(temp_client, tfa)
      temp_client.create_authorization(auth_settings.merge(tfa_settings(tfa)))
    rescue Octokit::Unauthorized
      cli.say cli.color 'Password Incorrect', :red
      temp_client.password = cli.pw_ask 'Reenter your GitHub password: '
      retry
    rescue Octokit::OneTimePasswordRequired
      tfa = cli.pw_ask 'Enter 2FA code: '
      make_auth(temp_client, cli, tfa)
    end

    def remove_old_auth(temp_client, tfa = nil)
      authorization = temp_client.authorizations(tfa_settings(tfa))
                                 .find { |a| a[:note] == human_name }
      return unless authorization

      temp_client.delete_authorization(authorization[:id], tfa_settings(tfa))
    end

    def human_name
      'UMTS Programmer Training'
    end

    def auth_settings
      {
        scopes: %w[user repo],
        note: human_name
      }
    end

    def tfa_settings(tfa = nil)
      tfa ? { headers: { 'X-Github-OTP' => tfa } } : {}
    end
  end
end
