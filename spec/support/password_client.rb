# frozen_string_literal: true

require 'ostruct'

class PasswordClient
  attr_accessor :password, :tfa

  def initialize(password: 'GOOD')
    @password = password
  end

  def create_authorization(params = {})
    if @password == 'GOOD' ||
       @password == 'TFA' && params.dig(:headers, 'X-Github-OTP')
      OpenStruct.new(token: '*')
    elsif @password == 'TFA'
      raise Octokit::OneTimePasswordRequired
    else
      raise Octokit::Unauthorized
    end
  end
end
