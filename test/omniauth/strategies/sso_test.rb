require 'test_helper'
require 'omniauth'
require 'rack/test'
require 'omniauth/strategies/sso'

class OmniAuth::Strategies::SSOTest < Minitest::Test
  include OmniAuth::Test::StrategyTestCase
  include Rack::Test::Methods

  def strategy
    [OmniAuth::Strategies::SSO, 'service_id', verify_key]
  end

  def test_callback
    post '/auth/sso/callback', t: ticket_string
    assert auth_hash
    assert_equal 'sso', auth_hash['provider']
    assert_equal 'ale@sso.net', auth_hash['uid']
    assert_equal 'ale@sso.net', auth_hash['info'].email
    assert_equal 'ale', auth_hash['info'].name
  end

  def test_invalid_callback
    post '/auth/my_strategy/callback', t: invalid_ticket_string
    assert_nil auth_hash
  end

  def auth_hash
    last_request.env['omniauth.auth']
  end

  def verify_key
    'c0dadbb483765b055d4f9ff5554d92b3ed7a433f15f4d8ebabbbd072510bfe23'
  end

  def ticket_string
    '4bHHseETK5U9YblImiqUpPHnEktAHIlICzb8w6jfrcrDyj/y7EtWoFVTvmTPcpJKHdh7TPPYgEVHVFH4DwKsCDN8YWxlfHNlcnZpY2UvfHNzby5uZXR8MTQxNTU3NDg0NHw='
  end

  def invalid_ticket_string
    '4bHHseETK5U9YblImiqUpPHnEktAHIlICzb8w6jfrcrDyj/y7EtWoFVTvmTPcpJKHdh7TPPYgEVHVFH4DwKsCDN8YWxlfHNlcnZpY2UvfHNzby5invalidQxNTU3NDg1NHw='
  end
end
