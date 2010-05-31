require 'test_helper'

class ServerAdaptersAfiliasTest < Test::Unit::TestCase

  def setup
    @definition = [:tld, ".foo", "whois.foo", {}]
    @klass  = Whois::Server::Adapters::Afilias
    @server = @klass.new(*@definition)
  end

  def test_query
    response = "No match for DOMAIN.FOO."
    expected = response
    @server.expects(:ask_the_socket).with("domain.foo", "whois.afilias-grs.info", 43).returns(response)
    answer   = @server.query("domain.foo")

    assert_equal response,
                 answer.to_s
    assert_equal [Whois::Answer::Part.new(response, "whois.afilias-grs.info")],
                 answer.parts
  end

  def test_query_with_referral
    referral = File.read(File.dirname(__FILE__) + "/../../../testcases/referrals/afilias.bz.txt")
    response = "Match for DOMAIN.FOO."
    expected = referral + "\n" + response
    @server.expects(:ask_the_socket).with("domain.foo", "whois.afilias-grs.info", 43).returns(referral)
    @server.expects(:ask_the_socket).with("domain.foo", "whois.belizenic.bz", 43).returns(response)
    answer   = @server.query("domain.foo")

    assert_equal expected,
                 answer.to_s
    assert_equal [Whois::Answer::Part.new(referral, "whois.afilias-grs.info"), Whois::Answer::Part.new(response, "whois.belizenic.bz")],
                 answer.parts
  end

end