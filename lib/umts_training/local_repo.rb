# frozen_string_literal: true

require 'git'

module UMTSTraining
  ##
  # Represents the git repository on disk. It uses the "origin" remote of
  # that repository to figure out the username and repository name on GitHub.
  class LocalRepo
    # The remote username
    attr_reader :user
    # The remote repository name
    attr_reader :name

    ##
    # `directory` is the path to a directory that contains a git repository.
    def initialize(directory)
      # git@github.com:user/repo.git  -or-
      # https://github.com/user/repo.git
      regex = %r{(?<user>[^/:]+)/(?<repo>[^/:.]+).git$}

      repo = Git.open(directory)
      match = repo.remote('origin').url.match(regex)
      @user = match[:user]
      @name = match[:repo]
    end

    ##
    # `<user>/<name>`. This is the format GitHub uses to refer to repositories
    # in their API.
    def github_name
      @user + '/' + @name
    end
  end
end
