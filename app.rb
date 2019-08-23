require 'dotenv/load'
require 'sinatra'
require 'json'
require 'rack/utils'

post '/payload' do
  payload_body = request.body.read
  verify_signature(payload_body)
  request.body.rewind
  push = JSON.parse(request.body.read)
  puts "I got some JSON: #{push.inspect}"
end

def verify_signature(payload_body)
  signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['SECRET_TOKEN'], payload_body)
  return halt 500, "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
end
