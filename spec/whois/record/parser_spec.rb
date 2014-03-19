require 'spec_helper'

describe Whois::Record::Parser do

  subject { described_class.new(record) }

  let(:record) { Whois::Record.new(nil, []) }


  describe ".parser_for" do
    it "returns the blank parser if the parser doesn't exist" do
      expect(described_class.parser_for(Whois::Record::Part.new(host: "whois.missing.test")).class.name).to eq("Whois::Record::Parser::Blank")
      expect(described_class.parser_for(Whois::Record::Part.new(host: "216.157.192.3")).class.name).to eq("Whois::Record::Parser::Blank")
    end
  end

  describe ".parser_klass" do
    it "returns the parser hostname converted into a class" do
      expect(described_class.parser_klass("whois.verisign-grs.com").name).to eq("Whois::Record::Parser::WhoisVerisignGrsCom")
    end

    it "recognizes and lazy-loads classes" do
      expect(described_class.parser_klass("whois.nic.it").name).to eq("Whois::Record::Parser::WhoisNicIt")
    end

    it "recognizes preloaded classes" do
      described_class.class_eval <<-RUBY
        class PreloadedParserTest
        end
      RUBY
      expect(described_class.parser_klass("preloaded.parser.test").name).to eq("Whois::Record::Parser::PreloadedParserTest")
    end

    it "successfully guesses the parser based on body for unknown host" do
      body = "domain: nic.pm\nstatus: ACTIVE\nhold: NO\nholder-c: APEM2-FRNIC\nadmin-c: NFC1-FRNIC\ntech-c: NFC1-FRNIC\nzone-c: NFC1-FRNIC\nnsl-id: NSL1-FRNIC\nremarks: Website at: http://www.nic.pm/\nremarks: Whois site at: whois.nic.fr\nremarks: Please email mailto: nic@nic.fr\nremarks: Spam mailto: abuse@nic.fr\nremarks: Test mailto: ping@nic.fr\nregistrar: AFNIC registry\nanniversary: 01/01\ncreated: 01/01/1995\nlast-update: 17/09/2004\nsource: FRNIC\n\nns-list: NSL1-FRNIC\nnserver: ns1.nic.fr [192.134.4.1 2001:660:3003:2::4:1]\nnserver: ns2.nic.fr [192.93.0.4 2001:660:3005:1::1:2]\nnserver: ns3.nic.fr [192.134.0.49 2001:660:3006:1::1:1]\nsource: FRNIC\n\nregistrar: AFNIC registry\ntype: Isp Option 2\nanonymous: YES\nregistered: 22/05/1997\nsource: FRNIC\n\nnic-hdl: NFC1-FRNIC\ntype: ROLE\ncontact: NIC France Contact\naddress: AFNIC\naddress: immeuble international\naddress: 2, rue Stephenson\naddress: Montigny le Bretonneux\naddress: 78181 Saint Quentin en Yvelines Cedex\ncountry: FR\nphone: +33 1 39 30 83 00\ne-mail: hostmaster@nic.fr\nadmin-c: NFC1-FRNIC\ntech-c: PL12-FRNIC\ntech-c: JP-FRNIC\ntech-c: MS1887-FRNIC\ntech-c: VL-FRNIC\ntech-c: PR1249-FRNIC\ntech-c: PV827-FRNIC\ntech-c: GO661-FRNIC\ntech-c: MS-FRNIC\ntech-c: AI1-FRNIC\nregistrar: AFNIC registry\nchanged: 23/08/2005 hostmaster@nic.fr\nanonymous: NO\nobsoleted: NO\nsource: FRNIC"
      expect(described_class.guess_klass(body).name).to eq("Whois::Record::Parser::WhoisNicFr")
    end

    it "raises LoadError if the parser doesn't exist" do
      expect { described_class.parser_klass("whois.missing.test") }.to raise_error(LoadError)
    end
  end

  describe ".host_to_parser" do
    it "converts hostnames to classes" do
      expect(described_class.host_to_parser("whois.it")).to eq("WhoisIt")
      expect(described_class.host_to_parser("whois.nic.it")).to eq("WhoisNicIt")
      expect(described_class.host_to_parser("whois.domain-registry.nl")).to eq("WhoisDomainRegistryNl")
    end

    it "converts dashes to upcase" do
      expect(described_class.host_to_parser("whois.domain-registry.nl")).to eq("WhoisDomainRegistryNl")
    end

    it "prefix IPs" do
      expect(described_class.host_to_parser("216.157.192.3")).to eq("Host2161571923")
    end

    it "downcases hostnames" do
      expect(described_class.host_to_parser("whois.PublicDomainRegistry.com")).to eq("WhoisPublicdomainregistryCom")
    end
  end


  describe "#initialize" do
    it "requires an record" do
      expect { described_class.new }.to raise_error(ArgumentError)
      expect { described_class.new(record) }.to_not raise_error
    end

    it "sets record from argument" do
      expect(described_class.new(record).record).to be(record)
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
      expect(subject.respond_to?(:to_s)).to be_true
    end

    it "returns true if method is in hierarchy" do
      expect(subject.respond_to?(:nil?)).to be_true
    end

    it "returns true if method is a property" do
      Whois::Record::Parser::PROPERTIES << :test_property
      expect(subject.respond_to?(:test_property)).to be_true
    end

    it "returns false if method is a property?" do
      Whois::Record::Parser::PROPERTIES << :test_property
      expect(subject.respond_to?(:test_property?)).to be_false
    end

    it "returns true if method is a method" do
      Whois::Record::Parser::METHODS << :test_method
      expect(subject.respond_to?(:test_method)).to be_true
    end

    it "returns false if method is a method" do
      Whois::Record::Parser::METHODS << :test_method
      expect(subject.respond_to?(:test_method?)).to be_false
    end
  end


  describe "property lookup" do
    require 'whois/record/parser/base'

    class Whois::Record::Parser::ParserSupportedTest < Whois::Record::Parser::Base
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

    class Whois::Record::Parser::ParserUndefinedTest < Whois::Record::Parser::Base
      property_supported :status do
        :status_undefined
      end
      # not defined          :created_on
      # not defined          :updated_on
      # not defined          :expires_on
    end

    class Whois::Record::Parser::ParserUnsupportedTest < Whois::Record::Parser::Base
      property_not_supported :status
      property_not_supported :created_on
      property_not_supported :updated_on
      property_not_supported :expires_on
    end

    it "delegates to first parser when all supported" do
      r = Whois::Record.new(nil, [Whois::Record::Part.new(body: "", host: "parser.supported.test"), Whois::Record::Part.new(body: "", host: "parser.undefined.test")])
      expect(described_class.new(r).status).to eq(:status_undefined)
      r = Whois::Record.new(nil, [Whois::Record::Part.new(body: "", host: "parser.undefined.test"), Whois::Record::Part.new(body: "", host: "parser.supported.test")])
      expect(described_class.new(r).status).to eq(:status_supported)
    end

    it "delegates to first parser when one supported" do
      r = Whois::Record.new(nil, [Whois::Record::Part.new(body: "", host: "parser.supported.test"), Whois::Record::Part.new(body: "", host: "parser.undefined.test")])
      expect(described_class.new(r).created_on).to eq(:created_on_supported)
      r = Whois::Record.new(nil, [Whois::Record::Part.new(body: "", host: "parser.undefined.test"), Whois::Record::Part.new(body: "", host: "parser.supported.test")])
      expect(described_class.new(r).created_on).to eq(:created_on_supported)
    end

    it "raises unless at least one is supported" do
      expect {
        r = Whois::Record.new(nil, [Whois::Record::Part.new(body: "", host: "parser.unsupported.test"), Whois::Record::Part.new(body: "", host: "parser.unsupported.test")])
        described_class.new(r).created_on
      }.to raise_error(Whois::AttributeNotSupported)
    end

    it "raises when parsers are undefined" do
      expect {
        r = Whois::Record.new(nil, [Whois::Record::Part.new(body: "", host: "parser.undefined.test"), Whois::Record::Part.new(body: "", host: "parser.undefined.test")])
        described_class.new(r).created_on
      }.to raise_error(Whois::AttributeNotImplemented)
    end

    it "raises when zero parts" do
      expect {
        r = Whois::Record.new(nil, [])
        described_class.new(r).created_on
      }.to raise_error(Whois::ParserError, /the Record is empty/)
    end

    it "does not delegate unknown properties" do
      expect {
        r = Whois::Record.new(nil, [Whois::Record::Part.new(body: "", host: "parser.undefined.test")])
        described_class.new(r).unknown_method
      }.to raise_error(NoMethodError)
    end
  end


  describe "#parsers" do
    it "returns 0 parsers when 0 parts" do
      record = Whois::Record.new(nil, [])
      parser = described_class.new(record)
      parser.parsers.should have(0).parsers
      parser.parsers.should == []
    end

    it "returns 1 parser when 1 part" do
      record = Whois::Record.new(nil, [Whois::Record::Part.new(body: nil, host: "whois.nic.it")])
      parser = described_class.new(record)
      parser.parsers.should have(1).parsers
    end

    it "returns 2 parsers when 2 part" do
      record = Whois::Record.new(nil, [Whois::Record::Part.new(body: nil, host: "whois.verisign-grs.com"), Whois::Record::Part.new(body: nil, host: "whois.nic.it")])
      parser = described_class.new(record)
      parser.parsers.should have(2).parsers
    end

    it "initializes the parsers in reverse order" do
      record = Whois::Record.new(nil, [Whois::Record::Part.new(body: nil, host: "whois.verisign-grs.com"), Whois::Record::Part.new(body: nil, host: "whois.nic.it")])
      parser = described_class.new(record)
      parser.parsers[0].should be_a(Whois::Record::Parser::WhoisNicIt)
      parser.parsers[1].should be_a(Whois::Record::Parser::WhoisVerisignGrsCom)
    end

    it "returns the host parser when the part is supported" do
      record = Whois::Record.new(nil, [Whois::Record::Part.new(body: nil, host: "whois.nic.it")])
      parser = described_class.new(record)
      parser.parsers.first.should be_a(Whois::Record::Parser::WhoisNicIt)
    end

    it "returns the Blank parser when the part is not supported" do
      record = Whois::Record.new(nil, [Whois::Record::Part.new(body: nil, host: "missing.nic.it")])
      parser = described_class.new(record)
      parser.parsers.first.should be_a(Whois::Record::Parser::Blank)
    end
  end

  describe "#property_any_supported?" do
    it "returns false when 0 parts" do
      record = Whois::Record.new(nil, [])
      described_class.new(record).property_any_supported?(:disclaimer).should be_false
    end

    it "returns true when 1 part supported" do
      record = Whois::Record.new(nil, [Whois::Record::Part.new(host: "whois.nic.it")])
      described_class.new(record).property_any_supported?(:disclaimer).should be_true
    end

    it "returns false when 1 part supported" do
      record = Whois::Record.new(nil, [Whois::Record::Part.new(host: "missing.nic.it")])
      described_class.new(record).property_any_supported?(:disclaimer).should be_false
    end

    it "returns true when 2 parts" do
      record = Whois::Record.new(nil, [Whois::Record::Part.new(host: "whois.verisign-grs.com"), Whois::Record::Part.new(host: "whois.nic.it")])
      described_class.new(record).property_any_supported?(:disclaimer).should be_true
    end

    it "returns true when 1 part supported 1 part not supported" do
      record = Whois::Record.new(nil, [Whois::Record::Part.new(host: "missing.nic.it"), Whois::Record::Part.new(host: "whois.nic.it")])
      described_class.new(record).property_any_supported?(:disclaimer).should be_true
    end
  end


  describe "#contacts" do
    class Whois::Record::Parser::Contacts1Test < Whois::Record::Parser::Base
    end

    class Whois::Record::Parser::Contacts2Test < Whois::Record::Parser::Base
      property_supported(:technical_contacts)   { ["p2-t1"] }
      property_supported(:admin_contacts)       { ["p2-a1"] }
      property_supported(:registrant_contacts)  { [] }
    end

    class Whois::Record::Parser::Contacts3Test< Whois::Record::Parser::Base
      property_supported(:technical_contacts)   { ["p3-t1"] }
    end

    it "returns an empty array when 0 parts" do
      record = Whois::Record.new(nil, [])
      parser = described_class.new(record)
      parser.contacts.should == []
    end

    it "returns an array of contact when 1 part is supported" do
      record = Whois::Record.new(nil, [Whois::Record::Part.new(body: nil, host: "contacts2.test")])
      parser = described_class.new(record)
      parser.contacts.should have(2).contacts
      parser.contacts.should == %w( p2-a1 p2-t1 )
    end

    it "returns an array of contact when 1 part is not supported" do
      record = Whois::Record.new(nil, [Whois::Record::Part.new(body: nil, host: "contacts1.test")])
      parser = described_class.new(record)
      parser.contacts.should have(0).contacts
      parser.contacts.should == %w()
    end

    it "merges the contacts and returns an array of contact when 2 parts" do
      record = Whois::Record.new(nil, [Whois::Record::Part.new(body: nil, host: "contacts2.test"), Whois::Record::Part.new(body: nil, host: "contacts3.test")])
      parser = described_class.new(record)
      parser.contacts.should have(3).contacts
      parser.contacts.should == %w( p3-t1 p2-a1 p2-t1 )
    end
  end


  describe "#changed?" do
    it "raises if the argument is not an instance of the same class" do
      lambda do
        described_class.new(record).changed?(Object.new)
      end.should raise_error

      lambda do
        described_class.new(record).changed?(described_class.new(record))
      end.should_not raise_error
    end
  end

  describe "#unchanged?" do
    it "raises if the argument is not an instance of the same class" do
      lambda do
        described_class.new(record).unchanged?(Object.new)
      end.should raise_error

      lambda do
        described_class.new(record).unchanged?(described_class.new(record))
      end.should_not raise_error
    end

    it "returns true if self and other references the same object" do
      instance = described_class.new(record)
      instance.unchanged?(instance).should be_true
    end

    it "returns false if parser and other.parser have different number of elements" do
      instance = described_class.new(Whois::Record.new(nil, []))
      other    = described_class.new(Whois::Record.new(nil, [Whois::Record::Part.new(body: "", host: "foo.example.test")]))
      instance.unchanged?(other).should be_false
    end

    it "returns true if parsers and other.parsers have 0 elements" do
      instance = described_class.new(Whois::Record.new(nil, []))
      other    = described_class.new(Whois::Record.new(nil, []))
      instance.unchanged?(other).should be_true
    end


    it "returns true if every parser in self marches the corresponding parser in other" do
      instance = described_class.new(Whois::Record.new(nil, [Whois::Record::Part.new(body: "hello", host: "foo.example.test"), Whois::Record::Part.new(body: "hello", host: "bar.example.test")]))
      other    = described_class.new(Whois::Record.new(nil, [Whois::Record::Part.new(body: "hello", host: "foo.example.test"), Whois::Record::Part.new(body: "hello", host: "bar.example.test")]))

      instance.unchanged?(other).should be_true
    end

    it "returns false unless every parser in self marches the corresponding parser in other" do
      instance = described_class.new(Whois::Record.new(nil, [Whois::Record::Part.new(body: "hello", host: "foo.example.test"), Whois::Record::Part.new(body: "world", host: "bar.example.test")]))
      other    = described_class.new(Whois::Record.new(nil, [Whois::Record::Part.new(body: "hello", host: "foo.example.test"), Whois::Record::Part.new(body: "baby!", host: "bar.example.test")]))

      instance.unchanged?(other).should be_false
    end
  end

  describe "#response_incomplete?" do
    it "returns false when all parts are complete" do
      instance = parsers("defined-false", "defined-false")
      expect(instance.response_incomplete?).to eq(false)
    end

    it "returns true when at least one part is incomplete" do
      instance = parsers("defined-false", "defined-true")
      expect(instance.response_incomplete?).to eq(true)

      instance = parsers("defined-true", "defined-false")
      expect(instance.response_incomplete?).to eq(true)
    end
  end

  describe "#response_throttled?" do
    it "returns false when all parts are not throttled" do
      instance = parsers("defined-false", "defined-false")
      expect(instance.response_throttled?).to eq(false)
    end

    it "returns true when at least one part is throttled" do
      instance = parsers("defined-false", "defined-true")
      expect(instance.response_throttled?).to eq(true)

      instance = parsers("defined-true", "defined-false")
      expect(instance.response_throttled?).to eq(true)
    end
  end

  describe "#response_unavailable?" do
    it "returns false when all parts are available" do
      instance = parsers("defined-false", "defined-false")
      expect(instance.response_unavailable?).to eq(false)
    end

    it "returns true when at least one part is unavailable" do
      instance = parsers("defined-false", "defined-true")
      expect(instance.response_unavailable?).to eq(true)

      instance = parsers("defined-true", "defined-false")
      expect(instance.response_unavailable?).to eq(true)
    end
  end


  private

  class Whois::Record::Parser::ResponseDefinedTrueTest < Whois::Record::Parser::Base
    def response_incomplete?
      true
    end
    def response_throttled?
      true
    end
    def response_unavailable?
      true
    end
  end

  class Whois::Record::Parser::ResponseDefinedFalseTest < Whois::Record::Parser::Base
    def response_incomplete?
      false
    end
    def response_throttled?
      false
    end
    def response_unavailable?
      false
    end
  end

  class Whois::Record::Parser::ResponseUndefinedTest < Whois::Record::Parser::Base
  end

  def parsers(*types)
    described_class.new(Whois::Record.new(nil, types.map { |type| Whois::Record::Part.new(body: "", host: "response-#{type}.test") }))
  end

end
