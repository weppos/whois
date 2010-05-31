require 'test_helper'
require 'whois/answer/parser/blank'

class AnswerParserBlankTest < Test::Unit::TestCase

  def setup
    @klass  = Whois::Answer::Parser::Blank
    @part   = Whois::Answer::Part.new("This is the response.", "whois.foo.com")
  end

  Whois::Answer::Parser::PROPERTIES.each do |method|
    define_method "test_#{method}_should_raise" do
      parser = @klass.new(@part)
      error  = assert_raise(Whois::ParserNotFound) { parser.send(method) }
      assert_match "whois.foo.com", error.message
    end
  end

end