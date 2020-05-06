# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem "sinatra", "~> 2.0"
gem "thin", "~> 1.7"
gem "json", "~> 2.2"
gem "resque", "~> 2.0"
gem "octokit", "~> 4.14"

group :development do
  gem "dotenv", "~> 2.7"
  gem "rerun", "~> 0.13.0"
  gem "foreman", "~> 0.85.0"
end

group :test do
  gem "rack-test", "~> 1.1"
  gem "mocha", "~> 1.9"
  gem "fakeredis", "~> 0.7.0"
  gem "webmock", "~> 3.6"
end

gem "rake", "~> 13.0"
