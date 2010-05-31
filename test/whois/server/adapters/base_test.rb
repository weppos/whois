require 'test_helper'

class ServerAdaptersBaseTest < Test::Unit::TestCase

  def setup
    @definition = [:tld, ".foo", "whois.foo", {}]
    @klass  = Whois::Server::Adapters::Base
    @server = @klass.new(*@definition)
  end

  def test_query_should_raise
    assert_raise(NotImplementedError) { @server.query("example.com") }
  end

end