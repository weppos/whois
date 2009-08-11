require 'test_helper'

class WhoisTest < Test::Unit::TestCase
  
  def setup
    @server   = Whois::Server.factory(:tld, ".it", "whois.nic.it")
    @response = Whois::Response.new("", @server)
  end
  
  def test_query
    Whois::Client.any_instance.expects(:query).with("foo.com")
    Whois.query("foo.com")
  end

  def test_whois
    Whois::Client.any_instance.expects(:query).with("foo.com")
    Whois.whois("foo.com")
  end

  def test_available_question
    @response.expects(:available?).returns(true)
    Whois::Client.any_instance.expects(:query).with("foo.com").returns(@response)
    assert Whois.available?("foo.com")
  end

  def test_registered_question
    @response.expects(:registered?).returns(true)
    Whois::Client.any_instance.expects(:query).with("foo.com").returns(@response)
    assert Whois.registered?("foo.com")
  end

end