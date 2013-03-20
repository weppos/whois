require 'spec_helper'

describe Whois::Record do

  subject { described_class.new(server, parts) }

  let(:server) {
    Whois::Server.factory(:tld, ".foo", "whois.example.test")
  }
  let(:parts) {[
    Whois::Record::Part.new(body: "This is a record from foo.", host: "foo.example.test"),
    Whois::Record::Part.new(body: "This is a record from bar.", host: "bar.example.test")
  ]}
  let(:content) {
    parts.map(&:body).join("\n")
  }


  describe "#initialize" do
    it "requires a server and parts" do
      lambda { described_class.new }.should raise_error(ArgumentError)
      lambda { described_class.new(server) }.should raise_error(ArgumentError)
      lambda { described_class.new(server, parts) }.should_not raise_error
    end
    
    it "sets server and parts from arguments" do
      instance = described_class.new(server, parts)
      instance.server.should be(server)
      instance.parts.should be(parts)

      instance = described_class.new(nil, nil)
      instance.server.should be_nil
      instance.parts.should be_nil
    end
  end


  describe "#respond_to?" do
    before(:all) do
      @_properties  = Whois::Record::Parser::PROPERTIES.dup
      @_methods     = Whois::Record::Parser::METHODS.dup
    end

    after(:all) do
      Whois::Record::Parser::PROPERTIES.clear
      Whois::Record::Parser::PROPERTIES.push(*@_properties)
      Whois::Record::Parser::METHODS.clear
      Whois::Record::Parser::METHODS.push(*@_methods)
    end

    it "returns true if method is in self" do
      subject.respond_to?(:to_s).should be_true
    end

    it "returns true if method is in hierarchy" do
      subject.respond_to?(:nil?).should be_true
    end

    it "returns true if method is a property" do
      Whois::Record::Parser::PROPERTIES << :test_property
      subject.respond_to?(:test_property).should be_true
    end

    it "returns true if method is a property?" do
      Whois::Record::Parser::PROPERTIES << :test_property
      subject.respond_to?(:test_property?).should be_true
    end

    it "returns true if method is a method" do
      Whois::Record::Parser::METHODS << :test_method
      subject.respond_to?(:test_method).should be_true
    end

    it "returns true if method is a method" do
      Whois::Record::Parser::METHODS << :test_method
      subject.respond_to?(:test_method?).should be_true
    end
  end

  describe "#to_s" do
    it "delegates to #content" do
      described_class.new(nil, [parts[0]]).to_s.should == parts[0].body
      described_class.new(nil, parts).to_s.should == parts.map(&:body).join("\n")
      described_class.new(nil, []).to_s.should == ""
    end
  end

  describe "#inspect" do
    it "inspects the record content" do
      described_class.new(nil, [parts[0]]).inspect.should == parts[0].body.inspect
    end

    it "joins multiple parts" do
      described_class.new(nil, parts).inspect.should == parts.map(&:body).join("\n").inspect
    end

    it "joins empty parts" do
      described_class.new(nil, []).inspect.should == "".inspect
    end
  end

  describe "#==" do
    it "returns true when other is the same instance" do
      one = two = described_class.new(server, parts)

      (one == two).should be_true
      (one.eql? two).should be_true
    end

    it "returns true when other has same class and has the same parts" do
      one, two = described_class.new(server, parts), described_class.new(server, parts)

      (one == two).should be_true
      (one.eql? two).should be_true
    end

    it "returns true when other has descendant class and has the same parts" do
      subklass = Class.new(described_class)
      one, two = described_class.new(server, parts), subklass.new(server, parts)

      (one == two).should be_true
      (one.eql? two).should be_true
    end

    it "returns true when other has same class and has equal parts" do
      one, two = described_class.new(server, parts), described_class.new(server, parts.dup)
      (one == two).should be_true
      (one.eql? two).should be_true
    end

    it "returns true when other has same class, different server and the same parts" do
      one, two = described_class.new(server, parts), described_class.new(nil, parts)
      (one == two).should be_true
      (one.eql? two).should be_true
    end

    it "returns false when other has different class and has the same parts" do
      one, two = described_class.new(server, parts), Struct.new(:server, :parts).new(server, parts)

      (one == two).should be_false
      (one.eql? two).should be_false
    end

    it "returns false when other has different parts" do
      one, two = described_class.new(server, parts), described_class.new(server, [])

      (one == two).should be_false
      (one.eql? two).should be_false
    end

    it "returns false when other is string and has the same content" do
      one, two = described_class.new(server, parts), described_class.new(server, parts).to_s

      (one == two).should be_false
      (one.eql? two).should be_false
    end

    it "returns false when other is string and has different content" do
      one, two = described_class.new(server, parts), "different"

      (one == two).should be_false
      (one.eql? two).should be_false
    end
  end


  describe "#match" do
    it "delegates to content" do
      subject.match(/record/).should be_a(MatchData)
      subject.match(/record/)[0].should == "record"

      subject.match(/nomatch/).should be_nil
    end
  end

  describe "#match?" do
    it "calls match and checks for match" do
      subject.match?(/record/).should  == true
      subject.match?(/nomatch/).should == false
    end
  end


  describe "#content" do
    it "returns the part body" do
      described_class.new(nil, [parts[0]]).content.should == parts[0].body
    end

    it "joins multiple parts" do
      described_class.new(nil, parts).content.should == parts.map(&:body).join("\n")
    end

    it "returns an empty string when no parts" do
      described_class.new(nil, []).content.should == ""
    end
  end

  describe "#parser" do
    it "returns a Parser" do
      subject.parser.should be_a(Whois::Record::Parser)
    end

    it "initializes the parser with self" do
      subject.parser.record.should be(subject)
    end

    it "memoizes the value" do
      subject.instance_eval { @parser }.should be_nil
      parser = subject.parser
      subject.instance_eval { @parser }.should be(parser)
    end
  end


  describe "#properties" do
    it "returns a Hash" do
      subject.properties.should be_a(Hash)
    end

    it "returns both nil and not-nil values" do
      subject.expects(:domain).returns("")
      subject.expects(:created_on).returns(nil)
      subject.expects(:expires_on).returns(Time.parse("2010-10-10"))
      properties = subject.properties
      properties[:domain].should == ""
      properties[:created_on].should == nil
      properties[:expires_on].should == Time.parse("2010-10-10")
    end

    it "fetches all parser property" do
      subject.properties.keys.should =~ Whois::Record::Parser::PROPERTIES
    end
  end


  class Whois::Record::Parser::WhoisPropertiesTest < Whois::Record::Parser::Base
    property_supported :status do
      nil
    end
    property_supported :created_on do
      Date.parse("2010-10-20")
    end
    property_not_supported :updated_on
    # property_not_defined :expires_on
  end

  describe "#property_any_supported?" do
    it "delegates to parsers" do
      subject.parser.expects(:property_any_supported?).with(:example).returns(true)
      subject.property_any_supported?(:example).should be_true
    end
  end

  describe "property" do
    it "returns value when the property is supported" do
      r = described_class.new(nil, [Whois::Record::Part.new(:body => "", :host => "whois.properties.test")])
      r.created_on.should == Date.parse("2010-10-20")
    end

    it "returns nil when the property is not supported" do
      r = described_class.new(nil, [Whois::Record::Part.new(:body => "", :host => "whois.properties.test")])
      r.updated_on.should be_nil
    end

    it "returns nil when the property is not implemented" do
      r = described_class.new(nil, [Whois::Record::Part.new(:body => "", :host => "whois.properties.test")])
      r.expires_on.should be_nil
    end
  end

  describe "property?" do
    it "returns true when the property is supported and has no value" do
      r = described_class.new(nil, [Whois::Record::Part.new(:body => "", :host => "whois.properties.test")])
      r.status?.should == false
    end

    it "returns false when the property is supported and has q value" do
      r = described_class.new(nil, [Whois::Record::Part.new(:body => "", :host => "whois.properties.test")])
      r.created_on?.should == true
    end

    it "returns false when the property is not supported" do
      r = described_class.new(nil, [Whois::Record::Part.new(:body => "", :host => "whois.properties.test")])
      r.updated_on?.should == false
    end

    it "returns false when the property is not implemented" do
      r = described_class.new(nil, [Whois::Record::Part.new(:body => "", :host => "whois.properties.test")])
      r.expires_on?.should == false
    end
  end


  describe "#changed?" do
    it "raises if the argument is not an instance of the same class" do
      lambda do
        described_class.new(nil, []).changed?(Object.new)
      end.should raise_error

      lambda do
        described_class.new(nil, []).changed?(described_class.new(nil, []))
      end.should_not raise_error
    end
  end

  describe "#unchanged?" do
    it "raises if the argument is not an instance of the same class" do
      lambda do
        described_class.new(nil, []).unchanged?(Object.new)
      end.should raise_error

      lambda do
        described_class.new(nil, []).unchanged?(described_class.new(nil, []))
      end.should_not raise_error
    end

    it "returns true if self and other references the same object" do
      instance = described_class.new(nil, [])
      instance.unchanged?(instance).should be_true
    end

    it "delegates to #parser if self and other references different objects" do
      other = described_class.new(nil, parts)
      instance = described_class.new(nil, parts)
      instance.parser.expects(:unchanged?).with(other.parser)

      instance.unchanged?(other)
    end
  end

  describe "#contacts" do
    it "delegates to parser" do
      subject.parser.expects(:contacts).returns([:one, :two])
      subject.contacts.should == [:one, :two]
    end
  end


  describe "#response_incomplete?" do
    it "delegates to #parser" do
      subject.parser.expects(:response_incomplete?)
      subject.response_incomplete?
    end
  end

  describe "#response_throttled?" do
    it "delegates to #parser" do
      subject.parser.expects(:response_throttled?)
      subject.response_throttled?
    end
  end

  describe "#response_unavailable?" do
    it "delegates to #parser" do
      subject.parser.expects(:response_unavailable?)
      subject.response_unavailable?
    end
  end


  describe "method_missing" do
    context "when a parser property"
    context "when a parser method"

    context "when a parser question method/property" do
      it "calls the corresponding no-question method" do
        subject.expects(:status)
        subject.status?
      end

      it "returns true if the property is not nil" do
        subject.expects(:status).returns("available")
        subject.status?.should == true
      end

      it "returns false if the property is nil" do
        subject.expects(:status).returns(nil)
        subject.status?.should == false
      end
    end

    context "when a simple method" do
      it "passes the request to super" do
        Object.class_eval do
          def happy; "yes"; end
        end

        record = described_class.new(nil, [])
        lambda do
          record.happy.should == "yes"
        end.should_not raise_error
        lambda do
          record.sad
        end.should raise_error(NoMethodError)
      end

      it "does not catch all methods" do
        lambda do
          described_class.new(nil, []).i_am_not_defined
        end.should raise_error(NoMethodError)
      end

      it "does not catch all question methods" do
        lambda do
          described_class.new(nil, []).i_am_not_defined?
        end.should raise_error(NoMethodError)
      end
    end
  end

end
