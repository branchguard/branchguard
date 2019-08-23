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
    post '/payload', {foo: 'bar'}
    assert last_response.unauthorized?
  end

  def test_it_rejects_improperly_signed_requests
    post '/payload', {foo: 'bar'}, { CONTENT_TYPE: "application/json", X_HUB_SIGNATURE: "12345" }
    assert last_response.unauthorized?
  end

  def test_it_accepts_properly_signed_requests
    post_json '/payload', {foo: 'bar'}
    assert last_response.ok?
  end

  def post_json(uri, data)
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['SECRET_TOKEN'], data.to_json)
    header 'X-Hub-Signature', signature
    post uri, data.to_json, { CONTENT_TYPE: "application/json", X_HUB_SIGNATURE: signature }
  end
end
