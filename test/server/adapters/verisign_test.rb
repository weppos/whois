require 'test_helper'

class ServerAdaptersVerisignTest < Test::Unit::TestCase

  def setup
    @definition = [:tld, ".foo", "whois.foo", {}]
    @klass  = Whois::Server::Adapters::Verisign
    @server = @klass.new(*@definition)
  end

  def test_query
    response = "No match for DOMAIN.FOO."
    expected = response
    @server.expects(:ask_the_socket).with("=domain.foo", "whois.foo", 43).returns(response)
    answer = @server.query("domain.foo")

    assert_equal expected,
                 answer.to_s
    assert_equal [Whois::Answer::Part.new(response, "whois.foo")],
                 answer.parts
  end

  def test_query_with_referral
    referral = File.read(File.dirname(__FILE__) + "/../../testcases/referrals/crsnic.com.txt")
    response = "Match for DOMAIN.FOO."
    expected = referral + "\n" + response
    @server.expects(:ask_the_socket).with("=domain.foo", "whois.foo", 43).returns(referral)
    @server.expects(:ask_the_socket).with("domain.foo", "whois.markmonitor.com", 43).returns(response)
    answer = @server.query("domain.foo")

    assert_equal expected,
                 answer.to_s
    assert_equal [Whois::Answer::Part.new(referral, "whois.foo"), Whois::Answer::Part.new(response, "whois.markmonitor.com")],
                 answer.parts
  end
  
  def test_query_with_referral_should_extract_the_closest_referral_server_with_more_servers
    referral = File.read(File.dirname(__FILE__) + "/../../testcases/referrals/crsnic.com_more_servers.txt")
    @server.expects(:ask_the_socket).with("=domain.foo", "whois.foo", 43).returns(referral)
    @server.expects(:ask_the_socket).with("domain.foo", "whois.markmonitor.com", 43).returns("")
    assert @server.query("domain.foo")
  end
  
  def test_query_with_referral_should_extract_the_closest_referral_server_with_more_servers
    referral = File.read(File.dirname(__FILE__) + "/../../testcases/referrals/crsnic.com_one_server.txt")
    @server.expects(:ask_the_socket).with("=domain.foo", "whois.foo", 43).returns(referral)
    @server.expects(:ask_the_socket).with("domain.foo", "whois.godaddy.com", 43).returns("")
    assert @server.query("domain.foo")
  end

end