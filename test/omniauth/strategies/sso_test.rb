require 'test_helper'
require 'omniauth'
require 'logger'
require 'rack/test'
require 'omniauth/strategies/sso'
require 'rbsso'

class OmniAuth::Strategies::SSOTest < Minitest::Test
  include OmniAuth::Test::StrategyTestCase
  include Rack::Test::Methods

  def setup
    OmniAuth.config.logger = Logger.new '/dev/null'
  end

  def strategy
    [OmniAuth::Strategies::SSO, 'https://my.service.id/', verify_key]
  end

  def test_redirect
    get 'auth/sso'
    assert last_response.redirect?
    assert_includes last_response.location,
      'https://neststaging.riseup.net/sso_auth'
    assert_includes last_response.location,
      "s=#{CGI.escape(service)}"
  end

  def test_valid_ticket
    post '/auth/sso/callback', t: ticket
    assert auth_hash
    assert_equal 'sso', auth_hash['provider']
    assert_equal 'user@domain', auth_hash['uid']
    assert_equal 'user@domain', auth_hash['info'].email
    assert_equal 'user', auth_hash['info'].name
  end

  def test_expired_ticket
    assert_raises RuntimeError do
      post '/auth/sso/callback', t: expired_ticket
    end
    assert_nil auth_hash
  end

  def test_invalid_ticket
    post '/auth/my_strategy/callback', t: invalid_ticket
    assert_nil auth_hash
  end

  def test_wrong_service
    assert_raises RuntimeError do
      post '/auth/sso/callback', t: ticket_for_other_service
    end
    assert_nil auth_hash
  end

  def auth_hash
    last_request.env['omniauth.auth']
  end

  def expired_ticket
    Time.stub :now, Time.at(123456) do
      ticket
    end
  end

  def ticket_for_other_service
    server.ticket user: user, service: 'other_service', domain: domain
  end

  # We modify the content of the ticket so the signature becomes invalid.
  # It still should have the right length and be Base64 compatible.
  def invalid_ticket
    ticket.tap do |string|
      string[100..112] = '///invalid///'
    end
  end

  def verify_key
    server.verify_key
  end

  def ticket
    server.ticket(user: user, service: service, domain: domain)
  end

  def server; RbSSO::Server.new seed; end
  def seed; '1234567890ABCDEF' * 4; end
  def user; 'user'; end
  def service; 'https://my.service.id/'; end
  def domain; 'domain'; end

end
