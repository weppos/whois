require 'test_helper'

class ServerAdaptersVerisignTest < Test::Unit::TestCase
  include Whois

  def setup
    @definition = [".foo", "whois.foo", {}]
    @klass = Server::Adapters::Verisign
    @server = @klass.new(*@definition)
  end

  def test_query
    expected = "No match for DOMAIN.FOO."
    @server.expects(:ask_the_socket).with("=domain.foo", "whois.crsnic.net", 43).returns(expected)
    assert_equal expected, @server.query("domain.foo")
  end

  def test_query_with_referral
    response = File.read(File.dirname(__FILE__) + "/../testcases/referrals/crsnic.com.txt")
    expected = "Match for DOMAIN.FOO."
    @server.expects(:ask_the_socket).with("=domain.foo", "whois.crsnic.net", 43).returns(response)
    @server.expects(:ask_the_socket).with("domain.foo", "whois.tucows.com", 43).returns(expected)
    assert_equal expected, @server.query("domain.foo")
  end

end