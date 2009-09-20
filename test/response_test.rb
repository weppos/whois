require 'test_helper'

class ResponseTest < Test::Unit::TestCase
  
  def setup
    @klass    = Whois::Response
    @server   = Whois::Server.factory(:tld, ".foo", "whois.foo")
    @parts    = [["This is a response for domain.foo.", "foo.whois.com"], ["This is a response for domain.bar.", "bar.whois.com"]]
    @content  = "This is a response for domain.foo.\nThis is a response for domain.bar."
    @response = @klass.new(@server, @parts)
  end


  def test_initialize
    response = @klass.new(@server, @parts)
    assert_instance_of @klass, response
    assert_equal @server, response.server
    assert_equal @parts, response.parts
  end
  
  def test_initialize_should_require_server
    assert_raise(ArgumentError) { @klass.new }
  end

  def test_initialize_should_require_responses
    assert_raise(ArgumentError) { @klass.new(@server) }
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

  def test_equality_check_self
    assert_equal      @response, @response
    assert  @response.eql?(@response)
  end

  def test_equality_check_string
    assert_equal      @response, @content
    assert_not_equal  @content, @response
    assert  @response.eql?(@content)
    assert !@content.eql?(@response)
  end

  def test_equality_check_content
    other = @klass.new(@server, @parts)
    assert_equal @response, other
    assert_equal other, @response
    assert @response.eql?(other)
    assert other.eql?(@response)
  end


  def test_content
    response = @klass.new(@server, @parts)
    assert_equal @content, response.content
  end

  def test_match?
    assert  @response.match?(/domain\.foo/)
    assert !@response.match?(/google/)
  end
  
  def test_i_m_feeling_lucky
    assert_equal "domain.foo", @response.i_m_feeling_lucky(/for (.*)\.$/)
    assert_equal nil, @response.i_m_feeling_lucky(/^invalid (.*)$/)
  end
  
  
  require 'whois/response/parsers/whois.nic.it'
  def test_parser
    response = @klass.new(nil, [["", "whois.nic.it"]])
    assert_instance_of  Whois::Response::Parsers::WhoisNicIt,
                        response.parser
  end

  def test_parser_should_raise_with_missing_parser
    response = @klass.new(nil, [["", "invalid.nic.it"]])
    error = assert_raise(Whois::ParserNotFound) { response.parser }
    assert_match /Unable to find a parser/, error.message
  end

  Whois::Response::Parsers::Base.allowed_methods.each do |method|
    define_method "test_should_delegate_#{method}_to_parser" do
      response = @klass.new(nil, [["", "whois.nic.it"]])
      parser   = response.parser
      parser.expects(method).returns(:value)
      assert_equal :value, response.send(method)
    end
  end

  def test_should_not_delegate_unallowed_method_to_parser
    response = @klass.new(nil, [["", "whois.nic.it"]])
    parser   = response.parser
    parser.expects("unallowed_method").never
    assert_raise(NoMethodError) { response.send("unallowed_method") }
  end

end