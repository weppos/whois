require 'test_helper'

class AnswerParserTest < Test::Unit::TestCase

  class Whois::Answer::Parser::WhoisAnswerParser1Fake < Whois::Answer::Parser::Base
  end

  class Whois::Answer::Parser::WhoisAnswerParser2Fake < Whois::Answer::Parser::Base
    property_supported(:technical_contact)   { "p2-t1" }
    property_supported(:admin_contact)       { "p2-a1" }
    property_supported(:registrant_contact)  { nil }
  end

  class Whois::Answer::Parser::WhoisAnswerParser3Fake < Whois::Answer::Parser::Base
    property_supported(:technical_contact)   { "p3-t1" }
  end


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


  def test_contacts_with_zero_parts
    answer = Whois::Answer.new(nil, [])
    parser = @klass.new(answer)
    assert_equal 0, parser.contacts.length
    assert_equal [], parser.contacts
  end

  def test_contacts_with_one_part
    answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "whois.answer-parser2.fake")])
    parser = @klass.new(answer)
    assert_equal 2, parser.contacts.length
    assert_equal ["p2-a1", "p2-t1"], parser.contacts
  end

  def test_contacts_with_one_part_unsupported
    answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "whois.answer-parser1.fake")])
    parser = @klass.new(answer)
    assert_equal 0, parser.contacts.length
    assert_equal [], parser.contacts
  end

  def test_contacts_with_two_parts
    answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "whois.answer-parser2.fake"), Whois::Answer::Part.new(nil, "whois.answer-parser3.fake")])
    parser = @klass.new(answer)
    assert_equal 3, parser.contacts.length
    assert_equal ["p3-t1", "p2-a1", "p2-t1"], parser.contacts
  end


  class Whois::Answer::Parser::TestParserSupported < Whois::Answer::Parser::Base
    property_supported :status do
      :status_supported
    end
    property_supported :created_on do
      :created_on_supported
    end
    property_supported :updated_on do
      :updated_on_supported
    end
    property_supported :expires_on do
      :expires_on_supported
    end
  end

  class Whois::Answer::Parser::TestParserUndefined < Whois::Answer::Parser::Base
    property_supported :status do
      :status_undefined
    end
    # not defined          :created_on
    # not defined          :updated_on
    # not defined          :expires_on
  end

  class Whois::Answer::Parser::TestParserUnsupported < Whois::Answer::Parser::Base
    property_not_supported :status
    property_not_supported :created_on
    property_not_supported :updated_on
    property_not_supported :expires_on
  end

  def test_delegate_property_to_parsers_should_delegate_to_first_with_all_supported
    answer = Whois::Answer.new(nil, [Whois::Answer::Part.new("", "test.parser.supported"), Whois::Answer::Part.new("", "test.parser.undefined")])
    parser = @klass.new(answer)
    assert_equal :status_undefined, parser.status

    answer = Whois::Answer.new(nil, [Whois::Answer::Part.new("", "test.parser.undefined"), Whois::Answer::Part.new("", "test.parser.supported")])
    parser = @klass.new(answer)
    assert_equal :status_supported, parser.status
  end

  def test_delegate_property_to_parsers_should_delegate_to_first_with_one_supported
    answer = Whois::Answer.new(nil, [Whois::Answer::Part.new("", "test.parser.supported"), Whois::Answer::Part.new("", "test.parser.undefined")])
    parser = @klass.new(answer)
    assert_equal :created_on_supported, parser.created_on
    answer = Whois::Answer.new(nil, [Whois::Answer::Part.new("", "test.parser.supported"), Whois::Answer::Part.new("", "test.parser.unsupported")])
    parser = @klass.new(answer)
    assert_equal :created_on_supported, parser.created_on
  end

  def test_delegate_property_to_parsers_should_raise_unless_supported
    answer = Whois::Answer.new(nil, [Whois::Answer::Part.new("", "test.parser.unsupported"), Whois::Answer::Part.new("", "test.parser.unsupported")])
    parser = @klass.new(answer)
    assert_raise(Whois::PropertyNotSupported) { parser.created_on }
  end

  def test_delegate_property_to_parsers_should_raise_unless_available
    answer = Whois::Answer.new(nil, [Whois::Answer::Part.new("", "test.parser.undefined"), Whois::Answer::Part.new("", "test.parser.undefined")])
    parser = @klass.new(answer)
    assert_raise(Whois::PropertyNotAvailable) { parser.created_on }
  end

  def test_delegate_property_to_parsers_should_raise_with_zero_parts
    answer = Whois::Answer.new(nil, [])
    parser = @klass.new(answer)
    assert_raise(Whois::ParserError) { parser.created_on }
  end

  def test_delegate_property_to_parser_should_not_delegate_unallowed_methods
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