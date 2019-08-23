ENV['APP_ENV'] = 'test'

require './app'
require 'test/unit'
require 'rack/test'

class BranchguardTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_rejects_unsigned_requests
    post '/payload'
    assert last_response.unauthorized?
  end
end
