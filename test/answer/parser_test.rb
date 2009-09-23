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


  def test_parsers_should_not_raise_with_valid_parser
    answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "whois.nic.it")])
    parser = @klass.new(answer)
    assert_equal 1, parser.parsers.length
    assert_instance_of Whois::Answer::Parser::WhoisNicIt, parser.parsers.first
  end

  def test_parsers_should_raise_with_missing_parser
    answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "invalid.nic.it")])
    parser = @klass.new(answer)
    error  = assert_raise(Whois::ParserNotFound) { parser.parsers }
    assert_match /Unable to find a parser/, error.message
  end

  def test_parsers_should_raise_with_empty_parts
    answer = Whois::Answer.new(nil, [])
    parser = @klass.new(answer)
    error  = assert_raise(Whois::ParserError) { parser.parsers }
  end

  # Whois::Answer::Parsers::Base.allowed_methods.each do |method|
  #   define_method "test_should_delegate_#{method}_to_parser" do
  #     answer = @klass.new(nil, [Whois::Answer::Part.new("", "whois.nic.it")])
  #     parser = answer.parser
  #     parser.expects(method).returns(:value)
  #     assert_equal :value, answer.send(method)
  #   end
  # end
  #
  # def test_should_not_delegate_unallowed_method_to_parser
  #   answer = @klass.new(nil, [Whois::Answer::Part.new("", "whois.nic.it")])
  #   parser = answer.parser
  #   parser.expects("unallowed_method").never
  #   assert_raise(NoMethodError) { answer.send("unallowed_method") }
  # end

end