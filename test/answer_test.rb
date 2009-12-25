require 'test_helper'

class AnswerTest < Test::Unit::TestCase

  def setup
    @klass    = Whois::Answer
    @server   = Whois::Server.factory(:tld, ".foo", "whois.foo")
    @parts    = [
        Whois::Answer::Part.new("This is a answer for domain.foo.", "foo.whois.com"),
        Whois::Answer::Part.new("This is a answer for domain.bar.", "bar.whois.com")
    ]
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

  def test_match?
    assert  @answer.match?(/domain\.foo/)
    assert !@answer.match?(/google/)
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


  def test_parser
    answer = @klass.new(nil, [Whois::Answer::Part.new("", "whois.nic.it")])
    assert_instance_of Whois::Answer::Parser, answer.parser

    answer = @klass.new(nil, [])
    assert_instance_of Whois::Answer::Parser, answer.parser
  end

  def test_properties
    answer = @klass.new(nil, [])
    answer.parser.expects(:property_available?).with(:domain).returns(true)
    answer.parser.expects(:property_available?).with(:domain_id).returns(true)
    answer.parser.expects(:property_available?).with(Not(any_of(:domain, :domain_id))).at_least(1).returns(false)
    answer.parser.expects(:domain).returns("foo.com")
    answer.parser.expects(:domain_id).returns(27)
    
    properties = answer.properties
    assert_equal 2, properties.keys.length
    assert_equal "foo.com", properties[:domain]
    assert_equal 27, properties[:domain_id]
  end

  def test_property_available?
    answer = @klass.new(nil, [])
    answer.parser.expects(:property_available?).with(:disclaimer).returns(:value)
    assert_equal :value, answer.property_available?(:disclaimer)
  end


  Whois::Answer::Parser.properties.each do |method|
    define_method "test_should_delegate_#{method}_to_parser" do
      answer = @klass.new(nil, [Whois::Answer::Part.new("", "whois.nic.it")])
      parser = answer.parser
      parser.expects(method).returns(:value)
      assert_equal :value, answer.send(method)
    end
  end

end