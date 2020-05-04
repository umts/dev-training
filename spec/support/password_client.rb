# frozen_string_literal: true

require 'ostruct'

class PasswordClient
  attr_accessor :password, :tfa

  def initialize(password: 'GOOD')
    @password = password
  end

  def create_authorization(params = {})
    raise Octokit::Unauthorized unless %w[GOOD TFA].include? @password
    if @password == 'TFA' && !params.dig(:headers, 'X-Github-OTP')
      raise Octokit::OneTimePasswordRequired
    end
    raise Octokit::UnprocessableEntity if params[:note].nil?

    OpenStruct.new(token: '*')
  end

  def authorizations(*_args)
    []
  end

  def delete_authorization(*_args)
    true
  end
end
