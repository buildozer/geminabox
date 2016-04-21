require 'octokit'
require_relative 'cache'

module Auth
  # Module for using GitHub authorization.
  module GitHub
    def self.github(access_token)
      Octokit::Client.new access_token: access_token
    end

    def self.user(access_token)
      github(access_token).user
    end

    def self.organizations(access_token)
      github(access_token).organizations
    end

    def self.in_organization?(access_token)
      organizations(access_token).any? do |organization|
        organization.login == ENV['GITHUB_ORGANIZATION']
      end
    end

    def self.authorized?(username, access_token)
      user(access_token).login == username && in_organization?(access_token).tap do |allowed|
        Auth::Cache.add(username, access_token) if allowed
      end
    rescue Octokit::Unauthorized
      false
    end
  end
end
