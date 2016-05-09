require 'sinatra/base'

class FakeGitHub < Sinatra::Base
  helpers do
    def protected!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted"'
      halt 401, "Not Authorized\n"
    end

    def authorized?
      @auth = Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? && @auth.basic? && @auth.credentials &&
        @auth.credentials == ['ben', 'password']
    end
  end
  post '/authorizations' do
    protected!
    json_response 201, 'authorization.json'
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(
      File.join(File.dirname(__FILE__), 'fixtures', file_name), 'rb'
    ).read
  end
end
