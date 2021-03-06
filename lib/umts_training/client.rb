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
    # Makes the authorization(s) required on initialization. `local_repo`
    # is a UMTSTraining::LocalRepo -- used for determining the GitHub user
    # (from the remote) -- and `cli` is a UMTSTraining::CLI -- used for
    # getting passwords from the user.
    def initialize(local_repo, cli)
      password = cli.pw_ask 'Enter your GitHub pasword: '
      temp_client = Octokit::Client.new(
        login: local_repo.user,
        password: password
      )

      @auth = make_auth(temp_client, cli)
      @client = Octokit::Client.new(access_token: auth.token)
    end

    private

    def make_auth(temp_client, cli, tfa = nil)
      prompt_for_tfa(temp_client)
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

    # rubocop:disable Lint/SuppressedException
    # Dummy POST to `/authorizations` to trigger SMS if applicable
    def prompt_for_tfa(temp_client)
      temp_client.create_authorization
    rescue Octokit::UnprocessableEntity, Octokit::OneTimePasswordRequired
    end
    # rubocop:enable Lint/SuppressedException

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
