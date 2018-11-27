# frozen_string_literal: true

require 'ostruct'

class TokenClient
  attr_accessor :access_token

  def initialize(access_token: '$')
    @access_token = access_token
  end

  def add_collaborator(*_args)
    true
  end

  def edit_repository(*_args)
    true
  end
end
