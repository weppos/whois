require 'test_helper'

class ServerAdaptersAfiliasTest < Test::Unit::TestCase
  include Whois

  def setup
    @definition = [:tld, ".foo", "whois.foo", {}]
    @klass = Server::Adapters::Afilias
    @server = @klass.new(*@definition)
  end

  def test_query
    response = "No match for DOMAIN.FOO."
    expected = response
    @server.expects(:ask_the_socket).with("domain.foo", "whois.afilias-grs.info", 43).returns(response)
    assert_equal expected, @server.query("domain.foo")
  end

  def test_query_with_referral
    referral = File.read(File.dirname(__FILE__) + "/../testcases/referrals/afilias.bz.txt")
    response = "Match for DOMAIN.FOO."
    expected = referral + "\n" + response
    @server.expects(:ask_the_socket).with("domain.foo", "whois.afilias-grs.info", 43).returns(referral)
    @server.expects(:ask_the_socket).with("domain.foo", "whois.belizenic.bz", 43).returns(response)
    assert_equal expected, @server.query("domain.foo")
  end

end