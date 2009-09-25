require 'test_helper'

class ServerAdaptersFormattedTest < Test::Unit::TestCase

  def setup
    @definition = [:tld, ".de", "whois.denic.de", {:format => "-T dn,ace -C US-ASCII %s"}]
    @klass  = Whois::Server::Adapters::Formatted
    @server = @klass.new(*@definition)
  end

  def test_query
    @server.expects(:ask_the_socket).with("-T dn,ace -C US-ASCII domain.foo", "whois.denic.de", 43).returns("Whois Response")
    response = @server.query("domain.foo")
    assert_equal "Whois Response",
                 response.to_s
    assert_equal [Whois::Answer::Part.new(response, "whois.denic.de")],
                 @server.buffer
  end

  def test_query_should_raise_without_option_format
    @server = @klass.new(*[:tld, ".de", "whois.denic.de", {}])
    @server.expects(:ask_the_socket).never
    assert_raise(Whois::ServerError) { @server.query("domain.foo") }
  end

end