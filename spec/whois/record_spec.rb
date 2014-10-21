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
      expect { described_class.new }.to raise_error(ArgumentError)
      expect { described_class.new(server) }.to raise_error(ArgumentError)
      expect { described_class.new(server, parts) }.not_to raise_error
    end
    
    it "sets server and parts from arguments" do
      instance = described_class.new(server, parts)
      expect(instance.server).to be(server)
      expect(instance.parts).to be(parts)

      instance = described_class.new(nil, nil)
      expect(instance.server).to be_nil
      expect(instance.parts).to be_nil
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
      expect(subject.respond_to?(:to_s)).to be_truthy
    end

    it "returns true if method is in hierarchy" do
      expect(subject.respond_to?(:nil?)).to be_truthy
    end

    it "returns true if method is a property" do
      Whois::Record::Parser::PROPERTIES << :test_property
      expect(subject.respond_to?(:test_property)).to be_truthy
    end

    it "returns true if method is a property?" do
      Whois::Record::Parser::PROPERTIES << :test_property
      expect(subject.respond_to?(:test_property?)).to be_truthy
    end

    it "returns true if method is a method" do
      Whois::Record::Parser::METHODS << :test_method
      expect(subject.respond_to?(:test_method)).to be_truthy
    end

    it "returns true if method is a method" do
      Whois::Record::Parser::METHODS << :test_method
      expect(subject.respond_to?(:test_method?)).to be_truthy
    end
  end

  describe "#to_s" do
    it "delegates to #content" do
      expect(described_class.new(nil, [parts[0]]).to_s).to eq(parts[0].body)
      expect(described_class.new(nil, parts).to_s).to eq(parts.map(&:body).join("\n"))
      expect(described_class.new(nil, []).to_s).to eq("")
    end
  end

  describe "#inspect" do
    it "inspects the record content" do
      expect(described_class.new(nil, [parts[0]]).inspect).to eq(parts[0].body.inspect)
    end

    it "joins multiple parts" do
      expect(described_class.new(nil, parts).inspect).to eq(parts.map(&:body).join("\n").inspect)
    end

    it "joins empty parts" do
      expect(described_class.new(nil, []).inspect).to eq("".inspect)
    end
  end

  describe "#==" do
    it "returns true when other is the same instance" do
      one = two = described_class.new(server, parts)

      expect(one == two).to be_truthy
      expect(one.eql? two).to be_truthy
    end

    it "returns true when other has same class and has the same parts" do
      one, two = described_class.new(server, parts), described_class.new(server, parts)

      expect(one == two).to be_truthy
      expect(one.eql? two).to be_truthy
    end

    it "returns true when other has descendant class and has the same parts" do
      subklass = Class.new(described_class)
      one, two = described_class.new(server, parts), subklass.new(server, parts)

      expect(one == two).to be_truthy
      expect(one.eql? two).to be_truthy
    end

    it "returns true when other has same class and has equal parts" do
      one, two = described_class.new(server, parts), described_class.new(server, parts.dup)
      expect(one == two).to be_truthy
      expect(one.eql? two).to be_truthy
    end

    it "returns true when other has same class, different server and the same parts" do
      one, two = described_class.new(server, parts), described_class.new(nil, parts)
      expect(one == two).to be_truthy
      expect(one.eql? two).to be_truthy
    end

    it "returns false when other has different class and has the same parts" do
      one, two = described_class.new(server, parts), Struct.new(:server, :parts).new(server, parts)

      expect(one == two).to be_falsey
      expect(one.eql? two).to be_falsey
    end

    it "returns false when other has different parts" do
      one, two = described_class.new(server, parts), described_class.new(server, [])

      expect(one == two).to be_falsey
      expect(one.eql? two).to be_falsey
    end

    it "returns false when other is string and has the same content" do
      one, two = described_class.new(server, parts), described_class.new(server, parts).to_s

      expect(one == two).to be_falsey
      expect(one.eql? two).to be_falsey
    end

    it "returns false when other is string and has different content" do
      one, two = described_class.new(server, parts), "different"

      expect(one == two).to be_falsey
      expect(one.eql? two).to be_falsey
    end
  end


  describe "#match" do
    it "delegates to content" do
      expect(subject.match(/record/)).to be_a(MatchData)
      expect(subject.match(/record/)[0]).to eq("record")

      expect(subject.match(/nomatch/)).to be_nil
    end
  end

  describe "#match?" do
    it "calls match and checks for match" do
      expect(subject.match?(/record/)).to  eq(true)
      expect(subject.match?(/nomatch/)).to eq(false)
    end
  end


  describe "#content" do
    it "returns the part body" do
      expect(described_class.new(nil, [parts[0]]).content).to eq(parts[0].body)
    end

    it "joins multiple parts" do
      expect(described_class.new(nil, parts).content).to eq(parts.map(&:body).join("\n"))
    end

    it "returns an empty string when no parts" do
      expect(described_class.new(nil, []).content).to eq("")
    end
  end

  describe "#parser" do
    it "returns a Parser" do
      expect(subject.parser).to be_a(Whois::Record::Parser)
    end

    it "initializes the parser with self" do
      expect(subject.parser.record).to be(subject)
    end

    it "memoizes the value" do
      expect(subject.instance_eval { @parser }).to be_nil
      parser = subject.parser
      expect(subject.instance_eval { @parser }).to be(parser)
    end
  end


  describe "#properties" do
    it "returns a Hash" do
      expect(subject.properties).to be_a(Hash)
    end

    it "returns both nil and not-nil values" do
      subject.expects(:domain).returns("")
      subject.expects(:created_on).returns(nil)
      subject.expects(:expires_on).returns(Time.parse("2010-10-10"))
      properties = subject.properties
      expect(properties[:domain]).to eq("")
      expect(properties[:created_on]).to eq(nil)
      expect(properties[:expires_on]).to eq(Time.parse("2010-10-10"))
    end

    it "fetches all parser property" do
      expect(subject.properties.keys).to match_array(Whois::Record::Parser::PROPERTIES)
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
      expect(subject.property_any_supported?(:example)).to be_truthy
    end
  end

  describe "property" do
    it "returns value when the property is supported" do
      r = described_class.new(nil, [Whois::Record::Part.new(:body => "", :host => "whois.properties.test")])
      expect(r.created_on).to eq(Date.parse("2010-10-20"))
    end

    it "returns nil when the property is not supported" do
      r = described_class.new(nil, [Whois::Record::Part.new(:body => "", :host => "whois.properties.test")])
      expect(r.updated_on).to be_nil
    end

    it "returns nil when the property is not implemented" do
      r = described_class.new(nil, [Whois::Record::Part.new(:body => "", :host => "whois.properties.test")])
      expect(r.expires_on).to be_nil
    end
  end

  describe "property?" do
    it "returns true when the property is supported and has no value" do
      r = described_class.new(nil, [Whois::Record::Part.new(:body => "", :host => "whois.properties.test")])
      expect(r.status?).to eq(false)
    end

    it "returns false when the property is supported and has q value" do
      r = described_class.new(nil, [Whois::Record::Part.new(:body => "", :host => "whois.properties.test")])
      expect(r.created_on?).to eq(true)
    end

    it "returns false when the property is not supported" do
      r = described_class.new(nil, [Whois::Record::Part.new(:body => "", :host => "whois.properties.test")])
      expect(r.updated_on?).to eq(false)
    end

    it "returns false when the property is not implemented" do
      r = described_class.new(nil, [Whois::Record::Part.new(:body => "", :host => "whois.properties.test")])
      expect(r.expires_on?).to eq(false)
    end
  end


  describe "#changed?" do
    it "raises if the argument is not an instance of the same class" do
      expect do
        described_class.new(nil, []).changed?(Object.new)
      end.to raise_error

      expect do
        described_class.new(nil, []).changed?(described_class.new(nil, []))
      end.not_to raise_error
    end
  end

  describe "#unchanged?" do
    it "raises if the argument is not an instance of the same class" do
      expect do
        described_class.new(nil, []).unchanged?(Object.new)
      end.to raise_error

      expect do
        described_class.new(nil, []).unchanged?(described_class.new(nil, []))
      end.not_to raise_error
    end

    it "returns true if self and other references the same object" do
      instance = described_class.new(nil, [])
      expect(instance.unchanged?(instance)).to be_truthy
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
      expect(subject.contacts).to eq([:one, :two])
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
        expect(subject.status?).to eq(true)
      end

      it "returns false if the property is nil" do
        subject.expects(:status).returns(nil)
        expect(subject.status?).to eq(false)
      end
    end

    context "when a simple method" do
      it "passes the request to super" do
        Object.class_eval do
          def happy; "yes"; end
        end

        record = described_class.new(nil, [])
        expect do
          expect(record.happy).to eq("yes")
        end.not_to raise_error
        expect do
          record.sad
        end.to raise_error(NoMethodError)
      end

      it "does not catch all methods" do
        expect do
          described_class.new(nil, []).i_am_not_defined
        end.to raise_error(NoMethodError)
      end

      it "does not catch all question methods" do
        expect do
          described_class.new(nil, []).i_am_not_defined?
        end.to raise_error(NoMethodError)
      end
    end
  end

end
