require 'spec_helper'
require 'whois/record/parser/base'


describe Whois::Record::Parser::Base do

  let(:part) {
    Whois::Record::Part.new(body: "This is the response.", host: "whois.example.test")
  }


  describe ".property_register" do
    it "register given property" do
      koncrete = Class.new(described_class)
      koncrete.property_register(:greetings, Whois::Record::Parser::PROPERTY_STATE_SUPPORTED)

      expect(koncrete._properties[:greetings]).to eq(Whois::Record::Parser::PROPERTY_STATE_SUPPORTED)
    end
  end

  describe "#property_supported?" do
    it "returns false if the property is not supported" do
      koncrete = Class.new(described_class) do
      end
      expect(koncrete.new(part).property_supported?(:disclaimer)).to be_falsey
      expect(koncrete.new(part).respond_to?(:disclaimer)).to be_truthy
    end

    it "returns true if the property is supported" do
      koncrete = Class.new(described_class) do
        property_register(:disclaimer, Whois::Record::Parser::PROPERTY_STATE_SUPPORTED) {}
      end
      expect(koncrete.new(part).property_supported?(:disclaimer)).to be_truthy
      expect(koncrete.new(part).respond_to?(:disclaimer)).to be_truthy
    end
  end


  describe "#initialize" do
    it "requires a part" do
      expect { described_class.new }.to raise_error(ArgumentError)
      expect { described_class.new(part) }.not_to raise_error
    end

    it "sets the part" do
      expect(described_class.new(part).part).to be(part)
    end
  end

  describe "#content" do
    it "returns the part body" do
      i = described_class.new(part)
      expect(i.content).to be(part.body)
    end
  end

  describe "#content_for_scanner" do
    it "returns the part body with line feed normalized" do
      i = described_class.new(Whois::Record::Part.new(:body => "This is\r\nthe response.", :host => "whois.example.test"))
      expect(i.send(:content_for_scanner)).to eq("This is\nthe response.")
    end

    it "caches the result" do
      i = described_class.new(Whois::Record::Part.new(:body => "This is\r\nthe response.", :host => "whois.example.test"))
      expect(i.instance_eval { @content_for_scanner }).to be_nil
      i.send(:content_for_scanner)
      expect(i.instance_eval { @content_for_scanner }).to eq("This is\nthe response.")
    end
  end

  describe "#is" do
    it "calls the method if the object respond to the method" do
      koncrete = Class.new(described_class) { def response_throttled?; true; end }.new(Whois::Record::Part.new)
      koncrete.is(:response_throttled?)
    end
    it "does not call the method if the object does not respond to the method" do
      koncrete = Class.new(described_class).new(Whois::Record::Part.new)
      expect(koncrete.is(:response_throttled?)).to be_falsey
    end
  end

  describe "#validate!" do
    it "raises Whois::ResponseIsThrottled when the response is throttled" do
      koncrete = Class.new(described_class) { def response_throttled?; true; end }.new(Whois::Record::Part.new)
      expect { koncrete.validate! }.to raise_error(Whois::ResponseIsThrottled)

      koncrete = Class.new(described_class) { def response_throttled?; false; end }.new(Whois::Record::Part.new)
      expect { koncrete.validate! }.not_to raise_error
    end

    it "raises Whois::ResponseIsUnavailable when the response is unavailable" do
      koncrete = Class.new(described_class) { def response_unavailable?; true; end }.new(Whois::Record::Part.new)
      expect { koncrete.validate! }.to raise_error(Whois::ResponseIsUnavailable)

      koncrete = Class.new(described_class) { def response_unavailable?; false; end }.new(Whois::Record::Part.new)
      expect { koncrete.validate! }.not_to raise_error
    end
  end


  describe "#changed?" do
    it "raises if the argument is not an instance of the same class" do
      expect do
        described_class.new(part).changed?(Object.new)
      end.to raise_error

      expect do
        described_class.new(part).changed?(described_class.new(part))
      end.not_to raise_error
    end
  end

  describe "#unchanged?" do
    it "raises if the argument is not an instance of the same class" do
      expect do
        described_class.new(part).unchanged?(Object.new)
      end.to raise_error

      expect do
        described_class.new(part).unchanged?(described_class.new(part))
      end.not_to raise_error
    end

    it "returns true if self and other references the same object" do
      i = described_class.new(part)
      expect(i.unchanged?(i)).to be_truthy
    end

    it "returns true if the content_for_scanner is the same" do
      i = described_class.new(Whois::Record::Part.new(:body => "This is the\nresponse 1.", :host => "whois.example.test"))
      o = described_class.new(Whois::Record::Part.new(:body => "This is the\r\nresponse 1.", :host => "whois.example.test"))
      expect(i.unchanged?(o)).to be_truthy
    end

    it "returns false if the content_for_scanner is not the same" do
      i = described_class.new(Whois::Record::Part.new(:body => "This is the response 1.", :host => "whois.example.test"))
      o = described_class.new(Whois::Record::Part.new(:body => "This is the response 2.", :host => "whois.example.test"))
      expect(i.unchanged?(o)).to be_falsey
    end
  end

  describe "#contacts" do
    it "returns an array of contacts" do
      c1 = Whois::Record::Contact.new(:id => "1st", :name => "foo")
      c2 = Whois::Record::Contact.new(:id => "2nd", :name => "foo")
      c3 = Whois::Record::Contact.new(:id => "3rd", :name => "foo")
      koncrete = Class.new(described_class) do
        property_supported(:registrant_contacts) { [c1, c2] }
        property_supported(:admin_contacts)      { [] }
        property_supported(:technical_contacts)  { [c3] }
      end.new(part)

      expect(koncrete.contacts).to eq([c1, c2, c3])
    end

    it "returns an empty array when no contact is supported" do
      i = described_class.new(part)
      expect(i.contacts).to eq([])
    end
  end


  describe "#response_incomplete?" do
    it "is undefined" do
      expect(described_class.new(part).respond_to?(:response_incomplete?)).to be_falsey
    end

    # it "returns nil" do
    #   i = described_class.new(part)
    #   i.response_incomplete?.should be_nil
    # end
    #
    # it "is false" do
    #   i = described_class.new(part)
    #   i.response_incomplete?.should be_false
    # end
  end

  describe "#response_throttled?" do
    it "is undefined" do
      expect(described_class.new(part).respond_to?(:response_throttled?)).to be_falsey
    end

    # it "returns nil" do
    #   i = described_class.new(part)
    #   i.response_throttled?.should be_nil
    # end
    #
    # it "is false" do
    #   i = described_class.new(part)
    #   i.response_throttled?.should be_false
    # end
  end

  describe "#response_unavailable?" do
    it "is undefined" do
      expect(described_class.new(part).respond_to?(:response_unavailable?)).to be_falsey
    end

    # it "returns nil" do
    #   i = described_class.new(part)
    #   i.response_unavailable?.should be_nil
    # end
    #
    # it "is false" do
    #   i = described_class.new(part)
    #   i.response_unavailable?.should be_false
    # end
  end

end

describe Whois::Record::Parser::Base, "Parser Behavior" do

  Klass = Class.new(Whois::Record::Parser::Base) do
    property_supported(:domain) { "example.com" }
    property_not_supported(:domain_id)

    def response_throttled?
      part.host == "throttled.whois.test"
    end
  end

  context "property supported" do
    it "raises Whois::ResponseIsThrottled when the response is throttled" do
      i = Klass.new(Whois::Record::Part.new(:body => "", :host => "throttled.whois.test"))
      expect { i.domain }.to raise_error(Whois::ResponseIsThrottled)

      i = Klass.new(Whois::Record::Part.new(:body => "", :host => "success.whois.test"))
      expect { i.domain }.to_not raise_error
    end
  end

  context "property not supported" do
    it "raises Whois::ResponseIsThrottled when the response is throttled" do
      i = Klass.new(Whois::Record::Part.new(:body => "", :host => "throttled.whois.test"))
      expect { i.domain_id }.to raise_error(Whois::AttributeNotSupported)

      i = Klass.new(Whois::Record::Part.new(:body => "", :host => "success.whois.test"))
      expect { i.domain_id }.to raise_error(Whois::AttributeNotSupported)
    end
  end

end
