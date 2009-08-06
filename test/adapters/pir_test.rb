require 'test_helper'

class ServerAdaptersPirTest < Test::Unit::TestCase
  include Whois

  def setup
    @definition = [:tld, ".foo", "whois.foo", {}]
    @klass = Server::Adapters::Pir
    @server = @klass.new(*@definition)
  end

  def test_query
    expected = "No match for DOMAIN.FOO."
    @server.expects(:ask_the_socket).with("FULL domain.foo", "whois.publicinterestregistry.net", 43).returns(expected)
    assert_equal expected, @server.query("domain.foo")
  end

  def test_query_with_referral
    response = File.read(File.dirname(__FILE__) + "/../testcases/referrals/pir.org.txt")
    expected = "Match for DOMAIN.FOO."
    @server.expects(:ask_the_socket).with("FULL domain.foo", "whois.publicinterestregistry.net", 43).returns(response)
    @server.expects(:ask_the_socket).with("domain.foo", "whois.iana.org", 43).returns(expected)
    assert_equal expected, @server.query("domain.foo")
  end

end