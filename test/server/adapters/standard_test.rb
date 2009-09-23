require 'test_helper'

class ServerAdaptersStandardTest < Test::Unit::TestCase

  def setup
    @definition = [:tld, ".foo", "whois.foo", {}]
    @klass  = Whois::Server::Adapters::Standard
    @server = @klass.new(*@definition)
  end

  def test_query
    @server.expects(:ask_the_socket).with("domain.foo", "whois.foo", 43).returns("Whois Response")
    response = @server.query("domain.foo")
    assert_equal "Whois Response", response.to_s
    assert_equal [Whois::Answer::Part.new(response, "whois.foo")],
                 @server.buffer
  end

  def test_query_with_port
    @server = @klass.new(:tld, ".foo", "whois.foo", { :port => 20 })
    @server.expects(:ask_the_socket).with("domain.foo", "whois.foo", 20).returns("Whois Response")
    response = @server.query("domain.foo")
    assert_equal "Whois Response",
                 response.to_s
    assert_equal [Whois::Answer::Part.new(response, "whois.foo")],
                 @server.buffer
  end

end