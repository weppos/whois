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


  def test_property_supported?
    klass = Class.new(@klass) do
    end
    assert !klass.new(@part).property_supported?(:disclaimer)
    assert  klass.new(@part).respond_to?(:disclaimer)

    klass = Class.new(@klass) do
      register_property(:disclaimer, :supported) {}
    end
    assert  klass.new(@part).property_supported?(:disclaimer)
    assert  klass.new(@part).respond_to?(:disclaimer)
  end


  def test_self_property_registry
    assert_instance_of Hash, @klass.property_registry
  end

  def test_self_property_registry_with_klass
    assert_instance_of Hash, @klass.property_registry(Whois::Answer::Parser::WhoisNicIt)
  end

  def test_self_property_registry_with_klass_should_initialize_to_empty_hash
    parser = Class.new
    assert_equal Hash.new, @klass.property_registry(parser)
  end

end