module UMTSTraining
  class Client
    attr_reader :auth, :client

    def initialize(local_repo, cli)
      password = cli.pw_ask 'Enter your GitHub pasword: '
      temp_client = Octokit::Client.new(
        login: local_repo.user,
        password: password
      )

      @auth = make_auth(temp_client)
      @client = Octokit::Client.new(access_token: auth.token)
      @repo = local_repo.github_name
    end

    def add_collaborators!(collaborators)
      collaborators.each do |collaborator|
        @client.add_collaborator(@repo, collaborator)
      end
    end

    private

    def auth_settings(tfa = nil)
      {}.tap do |h|
        h[:scopes] = %w(user repo)
        h[:note] = 'UMTS Programmer Training'
        h[:headers] = { headers: { 'X-Github-OTP' => tfa } } if tfa
      end
    end

    def make_auth(temp_client)
      temp_client.create_authorization(auth_settings)
    rescue Octokit::OneTimePasswordRequired
      tfa = cli.pw_ask 'Enter 2FA code: '
      temp_client.create_authorization(auth_settings(tfa))
    end
  end
end
