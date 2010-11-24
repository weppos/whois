require 'test_helper'

class ServerAdaptersBaseTest < Test::Unit::TestCase

  def setup
    @definition = [:tld, ".test", "whois.test", {}]
    @klass  = Whois::Server::Adapters::Base
    @server = @klass.new(*@definition)
  end

  def test_eql_with_same_object
    one, two = @server, @server

    assert one.equal?(two)
    assert one == two
    assert one.eql?(two)
  end

  def test_eql_with_same_properties
    one, two = @klass.new(*@definition), @klass.new(*@definition)

    assert !one.equal?(two)
    assert  one == two
    assert  one.eql?(two)
  end

  def test_eql_with_different_properties
    one, two = @klass.new(:tld, ".test", "whois.test"), @klass.new(:tld, ".cool", "whois.test")

    assert  one != two
    assert !one.eql?(two)
  end

  def test_query_should_raise
    assert_raise(NotImplementedError) { @server.query("example.com") }
  end

end