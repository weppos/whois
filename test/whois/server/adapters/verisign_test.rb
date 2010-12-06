require 'test_helper'

class ServerAdaptersVerisignTest < Test::Unit::TestCase

  # FIXME: teardown definition changes
  def setup
    @definition = [:tld, ".foo", "whois.foo", {}]
    @klass  = Whois::Server::Adapters::Verisign
    @server = @klass.new(*@definition)
  end

  def test_query
    response1 = "No match for DOMAIN.FOO."
    @server.expects(:ask_the_socket).with("=domain.foo", "whois.foo", 43).returns(response1)

    record = @server.query("domain.foo")
    assert_equal response1, record.to_s
    assert_equal 1, record.parts.size
    assert_equal [Whois::Answer::Part.new(response1, "whois.foo")],
                 record.parts
  end

  def test_query_with_referral
    response1 = File.read(fixture("referrals/crsnic.com.txt"))
    response2 = "Match for DOMAIN.FOO."
    @server.expects(:ask_the_socket).with("=domain.foo", "whois.foo", 43).returns(response1)
    @server.expects(:ask_the_socket).with("domain.foo", "whois.markmonitor.com", 43).returns(response2)

    record = @server.query("domain.foo")
    assert_equal response1 + "\n" + response2, record.to_s
    assert_equal 2, record.parts.size
    assert_equal [Whois::Answer::Part.new(response1, "whois.foo"), Whois::Answer::Part.new(response2, "whois.markmonitor.com")],
                 record.parts
  end

  def test_query_with_referral_not_defined_should_ignore_referral
    response1 = File.read(fixture("referrals/crsnic.com_referral_not_defined.txt"))
    @server.expects(:ask_the_socket).with("=domain.foo", "whois.foo", 43).returns(response1)
    @server.expects(:ask_the_socket).never

    record = @server.query("domain.foo")
    assert_equal 1, record.parts.size
  end

  def test_query_with_referral_should_extract_the_closest_referral_server_with_more_servers
    response1 = File.read(fixture("referrals/crsnic.com_referral_multiple.txt"))
    @server.expects(:ask_the_socket).with("=domain.foo", "whois.foo", 43).returns(response1)
    @server.expects(:ask_the_socket).with("domain.foo", "whois.markmonitor.com", 43).returns("")

    record = @server.query("domain.foo")
    assert_equal 2, record.parts.size
  end

  def test_query_with_referral_should_extract_the_closest_referral_server_with_more_servers
    response1 = File.read(fixture("referrals/crsnic.com_referral.txt"))
    @server.expects(:ask_the_socket).with("=domain.foo", "whois.foo", 43).returns(response1)
    @server.expects(:ask_the_socket).with("domain.foo", "whois.godaddy.com", 43).returns("")

    record = @server.query("domain.foo")
    assert_equal 2, record.parts.size
  end

end
