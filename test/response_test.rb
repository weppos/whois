require 'test_helper'

class ResponseTest < Test::Unit::TestCase
  
  def setup
    @klass    = Whois::Response
    @server   = Whois::Server.factory(:tld, ".foo", "whois.foo")
    @content  = "This is a response for domain.foo."
    @response = @klass.new(@content, @server)
  end
  
  def test_initialize
    response = @klass.new(@content)
    assert_instance_of @klass, response
    assert_equal @content, response.content
    assert_equal nil, response.server
  end
  
  def test_initialize_with_server
    response = @klass.new(@content, @server)
    assert_instance_of @klass, response
    assert_equal @content, response.content
    assert_equal @server, response.server
  end
  
  def test_to_s
    assert_equal @content, @response.to_s
  end
  
  def test_inspect
    assert_equal @content.inspect, @response.inspect
  end
  
  def test_match
    # Force .to_a otherwise Match will be compared as Object instance
    # and the test will fail because they actually are different instances.
    assert_equal @content.match(/domain\.foo/).to_a, @response.match(/domain\.foo/).to_a
    assert_equal @content.match(/google/), @response.match(/google/)
  end

  def test_equality_with_self
    assert_equal      @response, @response
    assert  @response.eql?(@response)
  end

  def test_equality_with_string
    assert_equal      @response, @content
    assert_not_equal  @content, @response
    assert  @response.eql?(@content)
    assert !@content.eql?(@response)
  end

  def test_equality
    other = @klass.new(@content, @server)
    assert_equal @response, other
    assert_equal other, @response
    assert @response.eql?(other)
    assert other.eql?(@response)
  end

  
  def test_match?
    assert  @response.match?(/domain\.foo/)
    assert !@response.match?(/google/)
  end
  
  def test_i_m_feeling_lucky
    assert_equal "domain.foo", @response.i_m_feeling_lucky(/for (.*)\.$/)
    assert_equal nil, @response.i_m_feeling_lucky(/^invalid (.*)$/)
  end
  
  
  def test_parser
    server   = Whois::Server.factory(:tld, ".it", "whois.nic.it")
    response = @klass.new("", server)
    assert_instance_of  Whois::Response::Parsers::WhoisNicIt,
                        response.parser
  end
  
  def test_parser_should_raise_with_missing_parser
    server   = Whois::Server.factory(:tld, ".it", "invalid.nic.it")
    response = @klass.new("", server)
    error = assert_raise(Whois::ParserNotFound) { response.parser }
    assert_match /Unable to find a parser/, error.message
  end
  
  def test_parser_should_raise_with_missing_server
    response = @klass.new("")
    error = assert_raise(Whois::ParserError) { response.parser }
    assert_match /Unable to select a parser/, error.message
  end

  Whois::Response::Parsers::Base.allowed_methods.each do |method|
    define_method "test_should_delegate_#{method}_to_parser" do
      server   = Whois::Server.factory(:tld, ".it", "whois.nic.it")
      response = @klass.new("", server)
      parser   = response.parser
      parser.expects(method).returns(:value)
      assert_equal :value, response.send(method)
    end
  end

  def test_should_not_delegate_unallowed_method_to_parser
    server   = Whois::Server.factory(:tld, ".it", "whois.nic.it")
    response = @klass.new("", server)
    parser   = response.parser
    parser.expects("unallowed_method").never
    assert_raise(NoMethodError) { response.send("unallowed_method") }
  end

end