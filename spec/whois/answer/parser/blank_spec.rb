require 'spec_helper'
require 'whois/answer/parser/blank'

describe Whois::Answer::Parser::Blank do

  before(:each) do
    @part = Whois::Answer::Part.new("This is the response.", "whois.example.test")
  end

  Whois::Answer::Parser::PROPERTIES.each do |method|
    describe method do
      it "raises Whois::ParserNotFound" do
        lambda do
          klass.new(@part).send(method)
        end.should raise_error(Whois::ParserNotFound, /whois.example.test/)
      end
    end
  end

end
