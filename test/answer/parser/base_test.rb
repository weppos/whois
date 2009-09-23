require 'test_helper'
require 'whois/answer/parser/base'

class AnswerParserBaseTest < Test::Unit::TestCase

  def setup
    @klass  = Whois::Answer::Parser::Base
    @part   = Whois::Answer::Part.new("This is the response.", "whois.foo.com")
  end


  def test_initialize
    parser = @klass.new(@part)
    assert_instance_of @klass, parser
  end

  def test_initialize_should_require_part
    assert_raise(ArgumentError) { @klass.new }
  end


  def test_content
    parser = @klass.new(@part)
    assert_equal @part.response, parser.content
  end

end