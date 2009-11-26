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


  # DEPRECATED
  def test_supported?
    klass = Class.new(@klass) do
      register_method(:disclaimer) {}
    end
    assert  klass.new(@part).property_supported?(:disclaimer)
    assert  klass.new(@part).respond_to?(:disclaimer)

    klass = Class.new(@klass) do
    end
    assert !klass.new(@part).property_supported?(:disclaimer)
    assert  klass.new(@part).respond_to?(:disclaimer)
  end

  # DEPRECATED
  def test_supported_should_return_false_unless_registrable_method
    parser = @klass.new(@part)
    assert !parser.property_supported?(:content)
    assert  parser.respond_to?(:content)
  end

  def test_property_supported?
    klass = Class.new(@klass) do
      register_method(:disclaimer) {}
    end
    assert  klass.new(@part).property_supported?(:disclaimer)
    assert  klass.new(@part).respond_to?(:disclaimer)

    klass = Class.new(@klass) do
    end
    assert !klass.new(@part).property_supported?(:disclaimer)
    assert  klass.new(@part).respond_to?(:disclaimer)
  end

  def test_property_supported_should_return_false_unless_registrable_method
    parser = @klass.new(@part)
    assert !parser.property_supported?(:content)
    assert  parser.respond_to?(:content)
  end


  def test_content
    parser = @klass.new(@part)
    assert_equal @part.response, parser.content
  end
  
end