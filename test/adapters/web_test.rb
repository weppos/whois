require 'test_helper'

class ServerAdaptersWebTest < Test::Unit::TestCase
  include Whois

  def setup
    @definition = [".foo", nil, { :web => "http://whois.foo" }]
    @klass = Server::Adapters::Web
    @server = @klass.new(*@definition)
  end

  def test_query
    error = assert_raise(WebInterfaceError) { @server.query("domain.foo") }
    assert_match /whois\.foo/, error.message
  end

end