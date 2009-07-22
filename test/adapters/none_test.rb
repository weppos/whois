require 'test_helper'

class ServerAdaptersNoneTest < Test::Unit::TestCase
  include Whois

  def setup
    @definition = [".foo", nil, {}]
    @klass = Server::Adapters::None
    @server = @klass.new(*@definition)
  end

  def test_query
    assert_raise(NoInterfaceError) { @server.query("domain.foo") }
  end

end