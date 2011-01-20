require "spec_helper"

describe Whois::Answer::Parser do

  before(:each) do
    @answer = Whois::Answer.new(nil, [])
  end


  describe "#initialize" do
    it "requires an answer" do
      lambda { klass.new }.should raise_error(ArgumentError)
      lambda { klass.new(@answer) }.should_not raise_error
    end

    it "sets answer from argument" do
      instance = klass.new(@answer)
      instance.answer.should be(@answer)
    end
  end


  describe "property lookup" do
    class Whois::Answer::Parser::ParserSupportedTest < Whois::Answer::Parser::Base
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

    class Whois::Answer::Parser::ParserUndefinedTest < Whois::Answer::Parser::Base
      property_supported :status do
        :status_undefined
      end
      # not defined          :created_on
      # not defined          :updated_on
      # not defined          :expires_on
    end

    class Whois::Answer::Parser::ParserUnsupportedTest < Whois::Answer::Parser::Base
      property_not_supported :status
      property_not_supported :created_on
      property_not_supported :updated_on
      property_not_supported :expires_on
    end

    it "delegates to first parser when all supported" do
      r = Whois::Answer.new(nil, [Whois::Answer::Part.new("", "parser.supported.test"), Whois::Answer::Part.new("", "parser.undefined.test")])
      klass.new(r).status.should == :status_undefined
      r = Whois::Answer.new(nil, [Whois::Answer::Part.new("", "parser.undefined.test"), Whois::Answer::Part.new("", "parser.supported.test")])
      klass.new(r).status.should == :status_supported
    end

    it "delegates to first parser when one supported" do
      r = Whois::Answer.new(nil, [Whois::Answer::Part.new("", "parser.supported.test"), Whois::Answer::Part.new("", "parser.undefined.test")])
      klass.new(r).created_on.should == :created_on_supported
      r = Whois::Answer.new(nil, [Whois::Answer::Part.new("", "parser.undefined.test"), Whois::Answer::Part.new("", "parser.supported.test")])
      klass.new(r).created_on.should == :created_on_supported
    end

    it "raises unless at least one is supported" do
      lambda do
        r = Whois::Answer.new(nil, [Whois::Answer::Part.new("", "parser.unsupported.test"), Whois::Answer::Part.new("", "parser.unsupported.test")])
        klass.new(r).created_on
      end.should raise_error(Whois::PropertyNotSupported)
    end

    it "raises if parsers are undefined" do
      lambda do
        r = Whois::Answer.new(nil, [Whois::Answer::Part.new("", "parser.undefined.test"), Whois::Answer::Part.new("", "parser.undefined.test")])
        klass.new(r).created_on
      end.should raise_error(Whois::PropertyNotAvailable)
    end

    it "raises with zero parts" do
      lambda do
        r = Whois::Answer.new(nil, [])
        klass.new(r).created_on
      end.should raise_error(Whois::ParserError)
    end

    it "doesn't delegate unknown properties" do
      lambda do
        r = Whois::Answer.new(nil, [Whois::Answer::Part.new("", "parser.undefined.test")])
        klass.new(r).unknown_method
      end.should raise_error(NoMethodError)
    end
  end


  describe "#parsers" do
    it "returns 0 parsers when 0 parts" do
      answer = Whois::Answer.new(nil, [])
      parser = @klass.new(answer)
      parser.parsers.should have(0).parsers
      parser.parsers.should == []
    end
  end



  describe "#changed?" do
    it "raises if the argument is not an instance of the same class" do
      lambda do
        klass.new(@answer).changed?(Object.new)
      end.should raise_error

      lambda do
        klass.new(@answer).changed?(klass.new(@answer))
      end.should_not raise_error
    end
  end

  describe "#unchanged?" do
    it "raises if the argument is not an instance of the same class" do
      lambda do
        klass.new(@answer).unchanged?(Object.new)
      end.should raise_error

      lambda do
        klass.new(@answer).unchanged?(klass.new(@answer))
      end.should_not raise_error
    end

    it "returns true if self and other references the same object" do
      instance = klass.new(@answer)
      instance.unchanged?(instance).should be_true
    end

    it "returns false if parser and other.parser have different number of elements" do
      instance = klass.new(Whois::Answer.new(nil, []))
      other    = klass.new(Whois::Answer.new(nil, [Whois::Answer::Part.new("", "foo.example.test")]))
      instance.unchanged?(other).should be_false
    end

    it "returns true if parsers and other.parsers have 0 elements" do
      instance = klass.new(Whois::Answer.new(nil, []))
      other    = klass.new(Whois::Answer.new(nil, []))
      instance.unchanged?(other).should be_true
    end


    it "returns true if every parser in self marches the corresponding parser in other" do
      instance = klass.new(Whois::Answer.new(nil, [Whois::Answer::Part.new("hello", "foo.example.test"), Whois::Answer::Part.new("world", "bar.example.test")]))
      other    = klass.new(Whois::Answer.new(nil, [Whois::Answer::Part.new("hello", "foo.example.test"), Whois::Answer::Part.new("world", "bar.example.test")]))

      instance.unchanged?(other).should be_true
    end

    it "returns false unless every parser in self marches the corresponding parser in other" do
      instance = klass.new(Whois::Answer.new(nil, [Whois::Answer::Part.new("hello", "foo.example.test"), Whois::Answer::Part.new("world", "bar.example.test")]))
      other    = klass.new(Whois::Answer.new(nil, [Whois::Answer::Part.new("hello", "foo.example.test"), Whois::Answer::Part.new("baby!", "bar.example.test")]))

      instance.unchanged?(other).should be_false
    end
  end


  describe ".parser_klass" do
    it "returns the parser hostname converted into a class" do
      require 'whois/answer/parser/whois.crsnic.net'
      klass.parser_klass("whois.crsnic.net").should == Whois::Answer::Parser::WhoisCrsnicNet
    end

    it "recognizes and lazy-loads classes" do
      klass.parser_klass("whois.nic.it").name.should == "Whois::Answer::Parser::WhoisNicIt"
    end

    it "recognizes preloaded classes" do
      klass.class_eval <<-RUBY
        class PreloadedParserTest
        end
      RUBY
      klass.parser_klass("preloaded.parser.test").name.should == "Whois::Answer::Parser::PreloadedParserTest"
    end

    it "returns the blank parser if the parser doesn't exist" do
      klass.parser_klass("whois.missing.test").name.should == "Whois::Answer::Parser::Blank"
    end
  end

  describe ".host_to_parser" do
    it "works" do
      klass.host_to_parser("whois.it").should == "WhoisIt"
      klass.host_to_parser("whois.nic.it").should == "WhoisNicIt"
      klass.host_to_parser("whois.domain-registry.nl").should == "WhoisDomainRegistryNl"
    end
  end

end
