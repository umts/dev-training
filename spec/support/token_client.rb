# frozen_string_literal: true

require 'ostruct'

class TokenClient
  attr_accessor :access_token

  def initialize(access_token: '$')
    @access_token = access_token
  end

  %i[add_collaborator edit_repository add_team_repository org_teams]
    .each do |meth|
      define_method meth do |*_args|
        true
      end
    end
end
