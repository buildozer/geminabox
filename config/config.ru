require "rubygems"
require "geminabox"
require "webrick"
require "webrick/https"

require_relative 'lib/auth'

Geminabox.data = "./data"

# Helpers for basic authentication
Geminabox::Server.helpers do
  def protected!
    unless authorized?
      response["WWW-Authenticate"] = %(Basic realm="Restricted Area")
      halt 401, "Forbidden.\n"
    end
  end

  def authorized?
    @auth ||= Rack::Auth::Basic::Request.new request.env
    return false unless @auth.provided? && @auth.basic? && @auth.credentials
    username = @auth.credentials[0]
    token = @auth.credentials[1]
    return Auth::Cache.authorized?(username, token) || Auth::GitHub.authorized?(username, token)
  end
end if ENV['GITHUB_ORGANIZATION']

Geminabox::Server.before { protected! }

# Web server SSL configuration
ssl_cert = OpenSSL::X509::Certificate.new(File.read(ENV['SSL_CERTIFICATE']))
ssl_private_key = OpenSSL::PKey::RSA.new(File.read(ENV['SSL_PRIVATE_KEY']), ENV['SSL_PASSPHRASE'])
ssl_intermediate_certs = [];
for i in 1...3
    name = ENV["SSL_INTERMEDIATE_CERTIFICATE_#{i}"]
    break unless name
    ssl_intermediate_certs << OpenSSL::X509::Certificate.new(File.read(name))
end

opts = {
  :Port              => 443,
  :Host              => "0.0.0.0",
  :SSLEnable         => true,
  :SSLVerifyClient   => OpenSSL::SSL::VERIFY_NONE,
  :SSLCertificate    => ssl_cert,
  :SSLExtraChainCert => ssl_intermediate_certs,
  :SSLPrivateKey     => ssl_private_key,
  :SSLCertName       => [["CN", WEBrick::Utils::getservername]],
  :app               => Geminabox::Server
}

# Start the Web server
Rack::Server.start opts