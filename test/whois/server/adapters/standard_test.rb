require 'test_helper'

class ServerAdaptersStandardTest < Test::Unit::TestCase

  def setup
    @definition = [:tld, ".foo", "whois.foo", {}]
    @klass  = Whois::Server::Adapters::Standard
    @server = @klass.new(*@definition)
  end

  def test_query
    response = "Whois Response"
    expected = response
    @server.expects(:ask_the_socket).with("domain.foo", "whois.foo", 43).returns(response)
    answer = @server.query("domain.foo")

    assert_equal expected,
                 answer.to_s
    assert_equal [Whois::Answer::Part.new(response, "whois.foo")],
                 answer.parts
  end

  def test_query_with_port
    response = "Whois Response"
    expected = response
    @server = @klass.new(:tld, ".foo", "whois.foo", { :port => 20 })
    @server.expects(:ask_the_socket).with("domain.foo", "whois.foo", 20).returns(response)
    answer = @server.query("domain.foo")

    assert_equal expected,
                 answer.to_s
    assert_equal [Whois::Answer::Part.new(response, "whois.foo")],
                 answer.parts
  end

end