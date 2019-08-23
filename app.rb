require 'dotenv/load'
require 'sinatra'
require 'json'
require 'rack/utils'
require 'resque'
require 'octokit'

class Branchguard < Sinatra::Application
  post '/payload' do
    payload_body = request.body.read
    verify_signature(payload_body)
    payload = JSON.parse(payload_body)
    if request.env['HTTP_X_GITHUB_EVENT'] == 'repository' && payload["action"] == 'created'
      Resque.enqueue(BranchguardWorker, payload)
    else
      return halt 202, "Unsupported Event"
    end
  end

  def verify_signature(payload_body)
    return halt 401 unless request.env['HTTP_X_HUB_SIGNATURE']
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['SECRET_TOKEN'], payload_body)
    return halt 401, "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end
end

class BranchguardWorker
  @queue = :events

  def self.perform(event)
    opts = {
      "accept": "application/vnd.github.luke-cage-preview+json",
      "enforce_admins": true,
      "required_pull_request_reviews": {
        "required_approving_review_count": 1
      }
    }
    repo = event["repository"]["full_name"]
    client = Octokit::Client.new(:access_token => ENV['GITHUB_API_TOKEN'])
    client.protect_branch(repo, "master", opts)
    issue = client.create_issue(
      repo,
      "Master branch protected",
      "@bval [BranchGuard](https://github.com/branchguard/branchguard) has automatically protected the master branch on this repo"
    )
    client.close_issue(repo, issue["number"])
  end
end
