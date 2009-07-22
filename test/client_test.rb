require 'test_helper'

class ClientTest < Test::Unit::TestCase
  include Whois
  
  def setup
    @client = Client.new
  end
  
  def test_query_with_email_address_should_raise
    assert_raise(ServerNotSupported) { @client.query("weppos@weppos.net") }
  end

  def test_query_with_domain_with_no_whois
    error = assert_raise(NoInterfaceError) { @client.query("weppos.ad") }
    assert_match /no whois server/, error.message
  end
  
  def test_query_with_domain_with_web_whois
    error = assert_raise(WebInterfaceError) { @client.query("weppos.ar") }
    assert_match /no whois server/, error.message
    assert_match /www\.nic\.ar/, error.message
  end


  need_connectivity do

    def test_query_with_domain
      response = @client.query("weppos.it")
      assert_match /Domain:\s+weppos\.it/, response
      assert_match /Created:/, response
    end

  end

end