require 'openssl'
require 'redis'
require 'securerandom'

module Auth
  # Caching methods for sessions.
  module Cache
    def self.redis_url
      @redis_host ||= ENV['REDIS_URL']
    end

    def self.redis
      @redis ||= Redis.new(url: redis_url)
    end

    def self.seed
      @seed ||= redis.get('rubygems:cache:seed') || SecureRandom.uuid.tap do |s|
        redis.set 'rubygems:cache:seed', s
      end
    end

    def self.session(username, token)
      data = "#{username}:#{token}"
      "rubygems:sessions:#{OpenSSL::HMAC.hexdigest OpenSSL::Digest::SHA256.new, seed, data}"
    end

    def self.add(username, token)
      redis.set session(username, token), true, ex: 300
    end

    def self.authorized?(username, token)
      redis.exists session(username, token)
    end
  end
end
