require 'test_helper'

class ClientTest < Test::Unit::TestCase
  include Whois
  
  def setup
    @client = Client.new
  end
  
  def test_query_with_email_address_should_raise
    assert_raise(ServerNotSupported) { @client.query("weppos@weppos.net") }
  end
  
  def test_query_with_domain
    response = @client.query("weppos.it")
    assert_match /Domain:\s+weppos\.it/, response
    assert_match /Created:/, response
  end
  
end