# frozen_string_literal: true

module UMTSTraining
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
end
