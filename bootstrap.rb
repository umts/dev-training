require 'bundler'
require 'yaml'
Bundler.require

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

  class CLI < ::HighLine
    def pw_ask(prompt)
      ask(prompt) { |q| q.echo = '*' }
    end
  end

  class LocalRepo
    attr_reader :user, :name

    def initialize(directory)
      repo = Git.open(directory)
      # git@github.com:user/repo.git  -or-
      # https://github.com/user/repo.git
      @user, @name = repo.remote.url.split(%r{[/:.]})[-3, 2]
    end

    def github_name
      @user + '/' + @name
    end
  end

  class Milestone
    def initialize(local_repo, client, yaml_file)
      @yaml = yaml_file
      @client = client.client # ugh
      @repo = local_repo.github_name
    end

    def create!
      @milestone ||= @client.create_milestone(@repo, 'Training exit interview')
    end

    def create_issues!
      ::YAML.load_stream(::File.open @yaml) do |document|
        @client.create_issue @repo,
                             document.fetch('title'),
                             format_body(document['description'],
                                         document['subtasks']),
                             milestone: @milestone.number
      end
    end

    def add_collaborators!(collaborators)
      collaborators.each do |collaborator|
        @client.add_collaborator(@repo, collaborator)
      end
    end

    private

    def format_body(desc, checklist)
      if checklist
        desc + "\n\n" + format_checklist(checklist)
      else
        desc
      end
    end

    def format_checklist(checklist)
      checklist.map do |item|
        "* [ ] #{item}"
      end.join("\n")
    end
  end
end

local_repo = UMTSTraining::LocalRepo.new File.dirname(__FILE__)
cli = UMTSTraining::CLI.new
client = UMTSTraining::Client.new local_repo, cli
milestone = UMTSTraining::Milestone.new local_repo,
                                        client,
                                        'qualifications.yml'

milestone.create!
milestone.create_issues!
milestone.add_collaborators! %w(werebus sherson dfaulken)
