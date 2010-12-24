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


  def test_contacts
    answer = @klass.new(@server, @parts)
    answer.parser.expects(:contacts).returns([])
    assert_equal [], answer.contacts
  end


  class Whois::Answer::Parser::WhoisParserFake < Whois::Answer::Parser::Base
    property_supported :status do
      nil
    end
    property_supported :created_on do
      Date.parse("2010-10-20")
    end
    property_not_supported :updated_on
    # property_not_defined :expires_on
  end

  def test_property_supported?
    answer = @klass.new(nil, [Whois::Answer::Part.new("", "whois.parser.fake")])
    assert  answer.property_supported?(:status)
    assert  answer.property_supported?(:created_on)
    assert !answer.property_supported?(:updated_on)
    assert !answer.property_supported?(:expires_on)
  end

  def test_should_return_value_with_supported_property_getter
    answer = @klass.new(nil, [Whois::Answer::Part.new("", "whois.parser.fake")])
    assert_equal Date.parse("2010-10-20"), answer.created_on
  end

  def test_should_return_nil_with_not_supported_property_getter
    answer = @klass.new(nil, [Whois::Answer::Part.new("", "whois.parser.fake")])
    assert_equal nil, answer.updated_on
  end

  def test_should_return_nil_with_not_implemented_property
    answer = @klass.new(nil, [Whois::Answer::Part.new("", "whois.parser.fake")])
    assert_equal nil, answer.expires_on
  end

  def test_should_return_false_with_supported_property_getter_and_not_value
    answer = @klass.new(nil, [Whois::Answer::Part.new("", "whois.parser.fake")])
    assert !answer.status?
  end

  def test_should_return_true_with_supported_property_getter_and_value
    answer = @klass.new(nil, [Whois::Answer::Part.new("", "whois.parser.fake")])
    assert  answer.created_on?
  end

  def test_should_return_false_with_not_supported_property_exists
    answer = @klass.new(nil, [Whois::Answer::Part.new("", "whois.parser.fake")])
    assert !answer.updated_on?
  end

  def test_should_return_false_with_not_implemented_property_exists
    answer = @klass.new(nil, [Whois::Answer::Part.new("", "whois.parser.fake")])
    assert !answer.expires_on?
  end

end