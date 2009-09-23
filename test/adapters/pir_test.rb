require 'test_helper'

class ServerAdaptersPirTest < Test::Unit::TestCase

  def setup
    @definition = [:tld, ".foo", "whois.foo", {}]
    @klass  = Whois::Server::Adapters::Pir
    @server = @klass.new(*@definition)
  end

  def test_query
    response = "No match for DOMAIN.FOO."
    expected = response
    @server.expects(:ask_the_socket).with("FULL domain.foo", "whois.publicinterestregistry.net", 43).returns(response)
    assert_equal expected,
                 @server.query("domain.foo").to_s
    assert_equal [Whois::Answer::Part.new(response, "whois.publicinterestregistry.net")],
                 @server.buffer
  end

  def test_query_with_referral
    referral = File.read(File.dirname(__FILE__) + "/../testcases/referrals/pir.org.txt")
    response = "Match for DOMAIN.FOO."
    expected = referral + "\n" + response
    @server.expects(:ask_the_socket).with("FULL domain.foo", "whois.publicinterestregistry.net", 43).returns(referral)
    @server.expects(:ask_the_socket).with("domain.foo", "whois.iana.org", 43).returns(response)
    assert_equal expected,
                 @server.query("domain.foo").to_s
    assert_equal [Whois::Answer::Part.new(referral, "whois.publicinterestregistry.net"), Whois::Answer::Part.new(response, "whois.iana.org")], 
                 @server.buffer
  end

end