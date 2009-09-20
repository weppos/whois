require 'test_helper'

class AnswerTest < Test::Unit::TestCase
  
  def setup
    @klass    = Whois::Answer
    @server   = Whois::Server.factory(:tld, ".foo", "whois.foo")
    @parts    = [["This is a answer for domain.foo.", "foo.whois.com"], ["This is a answer for domain.bar.", "bar.whois.com"]]
    @content  = "This is a answer for domain.foo.\nThis is a answer for domain.bar."
    @answer   = @klass.new(@server, @parts)
  end


  def test_initialize
    answer = @klass.new(@server, @parts)
    assert_instance_of @klass, answer
    assert_equal @server, answer.server
    assert_equal @parts, answer.parts
  end
  
  def test_initialize_should_require_server
    assert_raise(ArgumentError) { @klass.new }
  end

  def test_initialize_should_require_parts
    assert_raise(ArgumentError) { @klass.new(@server) }
  end


  def test_to_s
    assert_equal @content, @answer.to_s
  end
  
  def test_inspect
    assert_equal @content.inspect, @answer.inspect
  end
  
  def test_match
    # Force .to_a otherwise Match will be compared as Object instance
    # and the test will fail because they actually are different instances.
    assert_equal @content.match(/domain\.foo/).to_a, @answer.match(/domain\.foo/).to_a
    assert_equal @content.match(/google/), @answer.match(/google/)
  end

  def test_equality_check_self
    assert_equal      @answer, @answer
    assert  @answer.eql?(@answer)
  end

  def test_equality_check_string
    assert_equal      @answer, @content
    assert_not_equal  @content, @answer
    assert  @answer.eql?(@content)
    assert !@content.eql?(@answer)
  end

  def test_equality_check_content
    other = @klass.new(@server, @parts)
    assert_equal @answer, other
    assert_equal other, @answer
    assert @answer.eql?(other)
    assert other.eql?(@answer)
  end


  def test_content
    answer = @klass.new(@server, @parts)
    assert_equal @content, answer.content
  end

  def test_match?
    assert  @answer.match?(/domain\.foo/)
    assert !@answer.match?(/google/)
  end
  
  def test_i_m_feeling_lucky
    assert_equal "domain.foo", @answer.i_m_feeling_lucky(/for (.*)\.$/)
    assert_equal nil, @answer.i_m_feeling_lucky(/^invalid (.*)$/)
  end
  
  
  require 'whois/answer/parsers/whois.nic.it'
  def test_parser
    answer = @klass.new(nil, [["", "whois.nic.it"]])
    assert_instance_of  Whois::Answer::Parsers::WhoisNicIt,
                        answer.parser
  end

  def test_parser_should_raise_with_missing_parser
    answer = @klass.new(nil, [["", "invalid.nic.it"]])
    error = assert_raise(Whois::ParserNotFound) { answer.parser }
    assert_match /Unable to find a parser/, error.message
  end

  Whois::Answer::Parsers::Base.allowed_methods.each do |method|
    define_method "test_should_delegate_#{method}_to_parser" do
      answer = @klass.new(nil, [["", "whois.nic.it"]])
      parser   = answer.parser
      parser.expects(method).returns(:value)
      assert_equal :value, answer.send(method)
    end
  end

  def test_should_not_delegate_unallowed_method_to_parser
    answer = @klass.new(nil, [["", "whois.nic.it"]])
    parser   = answer.parser
    parser.expects("unallowed_method").never
    assert_raise(NoMethodError) { answer.send("unallowed_method") }
  end

end