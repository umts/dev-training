# frozen_string_literal: true

require 'git'

module UMTSTraining
  class LocalRepo
    attr_reader :user, :name

    def initialize(directory)
      # git@github.com:user/repo.git  -or-
      # https://github.com/user/repo.git
      regex = %r{(?<user>[^/:]+)/(?<repo>[^/:.]+).git$}

      repo = Git.open(directory)
      match = repo.remote('origin').url.match(regex)
      @user = match[:user]
      @name = match[:repo]
    end

    def github_name
      @user + '/' + @name
    end
  end
end
