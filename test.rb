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
    header 'X-Hub-Signature', '12345'
    post '/payload', {foo: 'bar'}
    assert last_response.unauthorized?
  end

  def test_it_accepts_properly_signed_requests
    post_json '/payload', {foo: 'bar'}
    assert last_response.ok?
  end

  def test_it_should_do_nothing_with_a_ping
    post_json '/payload', {foo: 'bar'}, 'ping'
    assert_equal last_response.status, 201
  end

  def post_json(uri, data, x_github_event = 'repository')
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['SECRET_TOKEN'], data.to_json)
    header 'X-Hub-Signature', signature
    header 'X-GitHub-Event', x_github_event
    post uri, data.to_json
  end
end
