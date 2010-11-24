require 'test_helper'

class ServerAdaptersPirTest < Test::Unit::TestCase

  def setup
    @definition = [:tld, ".foo", "whois.foo", {}]
    @klass  = Whois::Server::Adapters::Pir
    @server = @klass.new(*@definition)
  end

  def test_query
    response1 = "No match for DOMAIN.FOO."
    @server.expects(:ask_the_socket).with("FULL domain.foo", "whois.publicinterestregistry.net", 43).returns(response1)

    record = @server.query("domain.foo")
    assert_equal response1, record.to_s
    assert_equal 1, record.parts.size
    assert_equal [Whois::Answer::Part.new(response1, "whois.publicinterestregistry.net")],
                 record.parts
  end

  def test_query_with_referral
    response1 = File.read(fixture("referrals/pir.org.txt"))
    response2 = "Match for DOMAIN.FOO."
    @server.expects(:ask_the_socket).with("FULL domain.foo", "whois.publicinterestregistry.net", 43).returns(response1)
    @server.expects(:ask_the_socket).with("domain.foo", "whois.iana.org", 43).returns(response2)

    record = @server.query("domain.foo")
    assert_equal response1 + "\n" + response2, record.to_s
    assert_equal 2, record.parts.size
    assert_equal [Whois::Answer::Part.new(response1, "whois.publicinterestregistry.net"), Whois::Answer::Part.new(response2, "whois.iana.org")],
                 record.parts
  end

end