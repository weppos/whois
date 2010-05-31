require 'test_helper'

class ServerAdaptersNotImplementedTest < Test::Unit::TestCase
  include Whois

  def setup
    @definition = [:tld, ".foo", nil, {}]
    @klass = Server::Adapters::NotImplemented
    @server = @klass.new(*@definition)
  end

  def test_query
    assert_raise(ServerNotImplemented) { @server.query("domain.foo") }
  end

end