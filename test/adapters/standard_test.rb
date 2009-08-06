require 'test_helper'

class ServerAdaptersStandardTest < Test::Unit::TestCase
  include Whois

  def setup
    @definition = [:tld, ".foo", "whois.foo", {}]
    @klass = Server::Adapters::Standard
    @server = @klass.new(*@definition)
  end

  def test_query
    @server.expects(:ask_the_socket).with("domain.foo", "whois.foo", 43)
    @server.query("domain.foo")
  end

  def test_query_with_port
    @server = @klass.new(:tld, ".foo", "whois.foo", { :port => 20 })
    @server.expects(:ask_the_socket).with("domain.foo", "whois.foo", 20)
    @server.query("domain.foo")
  end

end