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

end