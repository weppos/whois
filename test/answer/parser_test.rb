require 'test_helper'

class AnswerParserTest < Test::Unit::TestCase

  def setup
    @klass  = Whois::Answer::Parser
    @answer = Whois::Answer.new(nil, [])
    @parser = @klass.new(@answer)
  end


  def test_initialize
    parser = @klass.new(@answer)
    assert_instance_of @klass, parser
    assert_equal @answer, parser.answer
  end

  def test_initialize_should_require_answer
    assert_raise(ArgumentError) { @klass.new }
  end


  def test_parsers_with_zero_parts
    answer = Whois::Answer.new(nil, [])
    parser = @klass.new(answer)
    assert_equal 0, parser.parsers.length
    assert_equal [], parser.parsers
  end

  def test_parsers_with_one_part_supported
    answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "whois.nic.it")])
    parser = @klass.new(answer)
    assert_equal 1, parser.parsers.length
    assert_instance_of Whois::Answer::Parser::WhoisNicIt, parser.parsers.first
  end

  def test_parsers_with_one_part_unsupported
    answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "invalid.nic.it")])
    parser = @klass.new(answer)
    assert_equal 1, parser.parsers.length
    assert_instance_of Whois::Answer::Parser::Blank, parser.parsers.first
  end

  def test_parsers_with_two_parts
    answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "whois.crsnic.net"), Whois::Answer::Part.new(nil, "whois.nic.it")])
    parser = @klass.new(answer)
    assert_equal 2, parser.parsers.length
    assert_instance_of Whois::Answer::Parser::WhoisNicIt, parser.parsers.first
    assert_instance_of Whois::Answer::Parser::WhoisCrsnicNet, parser.parsers.last
  end


  # DEPRECATED
  def test_supported_with_zero_parts
    answer = Whois::Answer.new(nil, [])
    parser = @klass.new(answer)
    assert !parser.supported?(:disclaimer)
  end

  # DEPRECATED
  def test_supported_with_one_part_supported
    answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "whois.nic.it")])
    parser = @klass.new(answer)
    assert  parser.supported?(:disclaimer)
  end

  # DEPRECATED
  def test_supported_with_one_part_unsupported
    answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "invalid.nic.it")])
    parser = @klass.new(answer)
    assert !parser.supported?(:disclaimer)
  end

  # DEPRECATED
  def test_supported_with_two_parts
    answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "whois.crsnic.net"), Whois::Answer::Part.new(nil, "whois.nic.it")])
    parser = @klass.new(answer)
    assert  parser.property_supported?(:disclaimer)
  end

  def test_property_supported_with_zero_parts
    answer = Whois::Answer.new(nil, [])
    parser = @klass.new(answer)
    assert !parser.property_supported?(:disclaimer)
  end

  def test_property_supported_with_one_part_supported
    answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "whois.nic.it")])
    parser = @klass.new(answer)
    assert  parser.property_supported?(:disclaimer)
  end

  def test_property_supported_with_one_part_unsupported
    answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "invalid.nic.it")])
    parser = @klass.new(answer)
    assert !parser.property_supported?(:disclaimer)
  end

  def test_property_supported_with_two_parts
    answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "whois.crsnic.net"), Whois::Answer::Part.new(nil, "whois.nic.it")])
    parser = @klass.new(answer)
    assert  parser.property_supported?(:disclaimer)
  end


  (Whois::Answer::Parser.properties - [:referral_url, :referral_whois]).each do |method|
    define_method "test_should_delegate_#{method}_to_parsers_first_parser_if_supported" do
      answer = Whois::Answer.new(nil, [Whois::Answer::Part.new("", "whois.nic.it")])
      parser = @klass.new(answer)
      parser.parsers.first.expects(method).returns(:value)
      assert_equal :value, parser.send(method)
    end
  end

  [:referral_url, :referral_whois].each do |method|
    define_method "test_should_delegate_#{method}_to_parsers_raise_unless_supported" do
      answer = Whois::Answer.new(nil, [Whois::Answer::Part.new("", "whois.nic.it")])
      parser = @klass.new(answer)
      assert_raise(Whois::PropertyNotSupported) { parser.send(method) }
    end
  end

  Whois::Answer::Parser.properties.each do |method|
    define_method "test_should_delegate_#{method}_to_parser_raise_with_no_zero_parts" do
      answer = Whois::Answer.new(nil, [])
      parser = @klass.new(answer)
      assert_raise(Whois::ParserError) { parser.send(method) }
    end
  end

  def test_should_not_delegate_unallowed_method_to_parser
    answer = Whois::Answer.new(nil, [Whois::Answer::Part.new("", "whois.nic.it")])
    parser = @klass.new(answer)
    parser.parsers.expects("unallowed_method").never
    assert_raise(NoMethodError) { parser.send("unallowed_method") }
  end


  def test_self_parser_klass
    assert_equal "Whois::Answer::Parser::WhoisNicIt", @klass.parser_klass("whois.nic.it").name
  end

  def test_self_parser_klass_with_preloaded_class
    @klass.class_eval <<-RUBY
      class WhoisFooBar
      end
    RUBY
    assert_equal "Whois::Answer::Parser::WhoisFooBar", @klass.parser_klass("whois.foo.bar").name
  end

  def test_self_parser_klass_should_return_blank_class_if_parser_doesnt_exist
    assert_equal "Whois::Answer::Parser::Blank", @klass.parser_klass("whois.missing").name
  end

  def test_self_host_to_parser
    assert_equal "WhoisIt", @klass.host_to_parser("whois.it")
    assert_equal "WhoisNicIt", @klass.host_to_parser("whois.nic.it")
    assert_equal "WhoisDomainRegistryNl", @klass.host_to_parser("whois.domain-registry.nl")
  end

end