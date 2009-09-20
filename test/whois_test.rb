require 'test_helper'

class WhoisTest < Test::Unit::TestCase
  
  def setup
    @server = Whois::Server.factory(:tld, ".it", "whois.nic.it")
    @answer = Whois::Answer.new("", @server)
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
    @answer.expects(:available?).returns(true)
    Whois::Client.any_instance.expects(:query).with("foo.com").returns(@answer)
    assert Whois.available?("foo.com")
  end

  def test_registered_question
    @answer.expects(:registered?).returns(true)
    Whois::Client.any_instance.expects(:query).with("foo.com").returns(@answer)
    assert Whois.registered?("foo.com")
  end

end