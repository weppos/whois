require "spec_helper"

describe Whois::Answer::Parser do

  before(:each) do
    @answer = Whois::Answer.new(nil, [])
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

    it "raises when parsers are undefined" do
      lambda do
        r = Whois::Answer.new(nil, [Whois::Answer::Part.new("", "parser.undefined.test"), Whois::Answer::Part.new("", "parser.undefined.test")])
        klass.new(r).created_on
      end.should raise_error(Whois::PropertyNotAvailable)
    end

    it "raises when zero parts" do
      lambda do
        r = Whois::Answer.new(nil, [])
        klass.new(r).created_on
      end.should raise_error(Whois::ParserError)
    end

    it "does not delegate unknown properties" do
      lambda do
        r = Whois::Answer.new(nil, [Whois::Answer::Part.new("", "parser.undefined.test")])
        klass.new(r).unknown_method
      end.should raise_error(NoMethodError)
    end
  end


  describe "#parsers" do
    it "returns 0 parsers when 0 parts" do
      answer = Whois::Answer.new(nil, [])
      parser = klass.new(answer)
      parser.parsers.should have(0).parsers
      parser.parsers.should == []
    end

    it "returns 1 parser when 1 part" do
      answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "whois.nic.it")])
      parser = klass.new(answer)
      parser.parsers.should have(1).parsers
    end

    it "returns 2 parsers when 2 part" do
      answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "whois.crsnic.net"), Whois::Answer::Part.new(nil, "whois.nic.it")])
      parser = klass.new(answer)
      parser.parsers.should have(2).parsers
    end

    it "initializes the parsers in reverse order" do
      answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "whois.crsnic.net"), Whois::Answer::Part.new(nil, "whois.nic.it")])
      parser = klass.new(answer)
      parser.parsers[0].should be_a(Whois::Answer::Parser::WhoisNicIt)
      parser.parsers[1].should be_a(Whois::Answer::Parser::WhoisCrsnicNet)
    end

    it "returns the host parser when the part is supported" do
      answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "whois.nic.it")])
      parser = klass.new(answer)
      parser.parsers.first.should be_a(Whois::Answer::Parser::WhoisNicIt)
    end

    it "returns the Blank parser when the part is not supported" do
      answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "missing.nic.it")])
      parser = klass.new(answer)
      parser.parsers.first.should be_a(Whois::Answer::Parser::Blank)
    end
  end

  describe "#property_supported?" do
    it "returns false when 0 parts" do
      answer = Whois::Answer.new(nil, [])
      klass.new(answer).property_supported?(:disclaimer).should be_false
    end

    it "returns true when 1 part supported" do
      answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "whois.nic.it")])
      klass.new(answer).property_supported?(:disclaimer).should be_true
    end

    it "returns false when 1 part supported" do
      answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "missing.nic.it")])
      klass.new(answer).property_supported?(:disclaimer).should be_false
    end

    it "returns true when 2 parts" do
      answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "whois.crsnic.net"), Whois::Answer::Part.new(nil, "whois.nic.it")])
      klass.new(answer).property_supported?(:disclaimer).should be_true
    end

    it "returns true when 1 part supported 1 part not supported" do
      answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "missing.nic.it"), Whois::Answer::Part.new(nil, "whois.nic.it")])
      klass.new(answer).property_supported?(:disclaimer).should be_true
    end
  end


  describe "#contacts" do
    class Whois::Answer::Parser::Contacts1Test < Whois::Answer::Parser::Base
    end

    class Whois::Answer::Parser::Contacts2Test < Whois::Answer::Parser::Base
      property_supported(:technical_contact)   { "p2-t1" }
      property_supported(:admin_contact)       { "p2-a1" }
      property_supported(:registrant_contact)  { nil }
    end

    class Whois::Answer::Parser::Contacts3Test< Whois::Answer::Parser::Base
      property_supported(:technical_contact)   { "p3-t1" }
    end

    it "returns an empty array when 0 parts" do
      answer = Whois::Answer.new(nil, [])
      parser = klass.new(answer)
      parser.contacts.should == []
    end

    it "returns an array of contact when 1 part is supported" do
      answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "contacts2.test")])
      parser = klass.new(answer)
      parser.contacts.should have(2).contacts
      parser.contacts.should == %w( p2-a1 p2-t1 )
    end

    it "returns an array of contact when 1 part is not supported" do
      answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "contacts1.test")])
      parser = klass.new(answer)
      parser.contacts.should have(0).contacts
      parser.contacts.should == %w()
    end

    it "merges the contacts and returns an array of contact when 2 parts" do
      answer = Whois::Answer.new(nil, [Whois::Answer::Part.new(nil, "contacts2.test"), Whois::Answer::Part.new(nil, "contacts3.test")])
      parser = klass.new(answer)
      parser.contacts.should have(3).contacts
      parser.contacts.should == %w( p3-t1 p2-a1 p2-t1 )
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

  describe "#throttle?" do
    it "returns false when all parts are not throttled" do
      i = parsers("defined-false", "defined-false")
      i.throttle?.should == false
    end

    it "returns true when at least one part is throttled" do
      i = parsers("defined-false", "defined-true")
      i.throttle?.should == true

      i = parsers("defined-true", "defined-false")
      i.throttle?.should == true
    end
  end

  describe "#incomplete?" do
    it "returns false when all parts are complete" do
      i = parsers("defined-false", "defined-false")
      i.incomplete?.should == false
    end

    it "returns true when at least one part is incomplete" do
      i = parsers("defined-false", "defined-true")
      i.incomplete?.should == true

      i = parsers("defined-true", "defined-false")
      i.incomplete?.should == true
    end
  end


  private

    class Whois::Answer::Parser::ResponseDefinedTrueTest < Whois::Answer::Parser::Base
      def throttle?
        true
      end
      def incomplete?
        true
      end
    end

    class Whois::Answer::Parser::ResponseDefinedFalseTest < Whois::Answer::Parser::Base
      def throttle?
        false
      end
      def incomplete?
        false
      end
    end

    class Whois::Answer::Parser::ResponseUndefinedTest < Whois::Answer::Parser::Base
    end

    def parsers(*types)
      klass.new(Whois::Answer.new(nil, types.map { |type| Whois::Answer::Part.new("", "response-#{type}.test")  }))
    end

end
