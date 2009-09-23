require 'test_helper'

class ServerAdaptersNoneTest < Test::Unit::TestCase
  include Whois

  def setup
    @klass = Server::Adapters::None
  end

  def test_query
    @server = @klass.new(:tld, ".foo", nil, {})
    error = assert_raise(NoInterfaceError) { @server.query("domain.foo") }
    assert_match /tld/, error.message
  end

  def test_query_with_ipv4
    @server = @klass.new(:ipv4, "127.0.0.1", nil, {})
    error = assert_raise(NoInterfaceError) { @server.query("domain.foo") }
    assert_match /ipv4/, error.message
  end

end