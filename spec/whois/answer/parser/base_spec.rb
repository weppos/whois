require 'spec_helper'

describe Whois::Answer::Parser::Base do

  before(:each) do
    @part = Whois::Answer::Part.new("This is the response.", "whois.example.test")
  end


  describe ".property_registry" do
    it "returns the @@registry variable when class argument is not passed" do
      with_registry do
        klass.property_registry.should == klass.send(:class_variable_get, :@@property_registry)
      end
    end

    it "returns the hash for given class when class argument is passed" do
      with_registry do
        pklass = Class.new(klass)
        klass.send(:class_variable_set, :@@property_registry, { pklass => {} })

        klass.property_registry[pklass].should == Hash.new
      end
    end

    it "lazy initializes the hash for given class" do
      with_registry do
        pklass = Class.new(klass)
        klass.send(:class_variable_set, :@@property_registry, Hash.new)
        klass.property_registry[pklass]
        klass.send(:class_variable_get, :@@property_registry).should == {}
      end
    end
  end

  describe ".property_register" do
    it "defines a public method called PROPERTY when block is given" do
      with_registry do
        pklass = Class.new(klass)
        pklass.public_instance_methods.map(&:to_sym).should_not include(:greetings)
        pklass.property_register(:greetings, :supported) {}
        pklass.public_instance_methods.map(&:to_sym).should include(:greetings)

        pklass = Class.new(klass)
        pklass.public_instance_methods.map(&:to_sym).should_not include(:greetings)
        pklass.property_register(:greetings, :supported)
        pklass.public_instance_methods.map(&:to_sym).should_not include(:greetings)
      end
    end

    it "defines a private method called internal_PROPERTY when block is given" do
      with_registry do
        pklass = Class.new(klass)
        pklass.private_instance_methods.map(&:to_sym).should_not include(:internal_greetings)
        pklass.property_register(:greetings, :supported) {}
        pklass.private_instance_methods.map(&:to_sym).should include(:internal_greetings)

        pklass = Class.new(klass)
        pklass.private_instance_methods.map(&:to_sym).should_not include(:internal_greetings)
        pklass.property_register(:greetings, :supported)
        pklass.private_instance_methods.map(&:to_sym).should_not include(:internal_greetings)
      end
    end
  end

  describe "#property_supported?" do
    it "returns false if the property is not supported" do
      k = Class.new(klass) do
      end
      k.new(@part).property_supported?(:disclaimer).should be_false
      k.new(@part).respond_to?(:disclaimer).should be_true
    end

    it "returns true if the property is supported" do
      k = Class.new(klass) do
        property_register(:disclaimer, :supported) {}
      end
      k.new(@part).property_supported?(:disclaimer).should be_true
      k.new(@part).respond_to?(:disclaimer).should be_true
    end
  end


  describe "#initialize" do
    it "requires a part" do
      lambda { klass.new }.should raise_error(ArgumentError)
      lambda { klass.new(@part) }.should_not raise_error
    end

    it "sets the part" do
      klass.new(@part).part.should be(@part)
    end
  end

  describe "#content" do
    it "returns the part body" do
      i = klass.new(@part)
      i.content.should be(@part.body)
    end
  end

  describe "#content_for_scanner" do
    it "returns the part body with line feed normalized" do
      i = klass.new(Whois::Answer::Part.new("This is\r\nthe response.", "whois.example.test"))
      i.send(:content_for_scanner).should == "This is\nthe response."
    end

    it "caches the result" do
      i = klass.new(Whois::Answer::Part.new("This is\r\nthe response.", "whois.example.test"))
      i.instance_eval { @content_for_scanner }.should be_nil
      i.send(:content_for_scanner)
      i.instance_eval { @content_for_scanner }.should == "This is\nthe response."
    end
  end

  describe "#is" do
    it "calls the method if the object respond to the method" do
      i = Class.new(klass) { def response_throttled?; true; end }.new(Whois::Answer::Part.new)
      i.is(:response_throttled?)
    end
    it "does not call the method if the object does not respond to the method" do
      i = Class.new(klass).new(Whois::Answer::Part.new)
      i.is(:response_throttled?).should be_false
    end
  end

  describe "#validate!" do
    it "raises Whois::ResponseIsThrottled when the response is throttled" do
      i = Class.new(klass) { def response_throttled?; true; end }.new(Whois::Answer::Part.new)
      lambda { i.validate! }.should raise_error(Whois::ResponseIsThrottled)

      i = Class.new(klass) { def response_throttled?; false; end }.new(Whois::Answer::Part.new)
      lambda { i.validate! }.should_not raise_error
    end
  end


  describe "#changed?" do
    it "raises if the argument is not an instance of the same class" do
      lambda do
        klass.new(@part).changed?(Object.new)
      end.should raise_error

      lambda do
        klass.new(@part).changed?(klass.new(@part))
      end.should_not raise_error
    end
  end

  describe "#unchanged?" do
    it "raises if the argument is not an instance of the same class" do
      lambda do
        klass.new(@part).unchanged?(Object.new)
      end.should raise_error

      lambda do
        klass.new(@part).unchanged?(klass.new(@part))
      end.should_not raise_error
    end

    it "returns true if self and other references the same object" do
      i = klass.new(@part)
      i.unchanged?(i).should be_true
    end

    it "returns true if the content_for_scanner is the same" do
      i = klass.new(Whois::Answer::Part.new("This is the\nresponse 1.", "whois.example.test"))
      o = klass.new(Whois::Answer::Part.new("This is the\r\nresponse 1.", "whois.example.test"))
      i.unchanged?(o).should be_true
    end

    it "returns false if the content_for_scanner is not the same" do
      i = klass.new(Whois::Answer::Part.new("This is the response 1.", "whois.example.test"))
      o = klass.new(Whois::Answer::Part.new("This is the response 2.", "whois.example.test"))
      i.unchanged?(o).should be_false
    end
  end

  describe "#contacts" do
    it "returns an array of contacts" do
      c1 = Whois::Answer::Contact.new(:id => "1st", :name => "foo")
      c2 = Whois::Answer::Contact.new(:id => "2nd", :name => "foo")
      c3 = Whois::Answer::Contact.new(:id => "3rd", :name => "foo")
      i  = Class.new(klass) do
        property_register(:registrant_contacts, :supported) { [c1, c2] }
        property_register(:admin_contacts, :supported)      { [] }
        property_register(:technical_contacts, :supported)  { [c3] }
      end.new(@part)

      i.contacts.should == [c1, c2, c3]
    end

    it "returns an empty array when no contact is supported" do
      i = klass.new(@part)
      i.contacts.should == []
    end
  end


  describe "#response_throttled?" do
    it "is undefined" do
      klass.new(@part).respond_to?(:response_throttled?).should be_false
    end

    # it "returns nil" do
    #   i = klass.new(@part)
    #   i.response_throttled?.should be_nil
    # end
    #
    # it "is false" do
    #   i = klass.new(@part)
    #   i.response_throttled?.should be_false
    # end
  end

  describe "#response_incomplete?" do
    it "is undefined" do
      klass.new(@part).respond_to?(:response_incomplete?).should be_false
    end

    # it "returns nil" do
    #   i = klass.new(@part)
    #   i.response_incomplete?.should be_nil
    # end
    #
    # it "is false" do
    #   i = klass.new(@part)
    #   i.response_incomplete?.should be_false
    # end
  end

  describe "#response_unavailable?" do
    it "is undefined" do
      klass.new(@part).respond_to?(:response_unavailable?).should be_false
    end

    # it "returns nil" do
    #   i = klass.new(@part)
    #   i.response_unavailable?.should be_nil
    # end
    #
    # it "is false" do
    #   i = klass.new(@part)
    #   i.response_unavailable?.should be_false
    # end
  end

end

describe Whois::Answer::Parser::Base, "Parser Behavior" do

  Klass = Class.new(Whois::Answer::Parser::Base) do
    property_supported(:domain) { "example.com" }
    property_not_supported(:domain_id)

    def response_throttled?
      part.host == "throttled.whois.test"
    end
  end

  context "property supported" do
    it "raises Whois::ResponseIsThrottled when the response is throttled" do
      i = Klass.new(Whois::Answer::Part.new("", "throttled.whois.test"))
      lambda { i.domain }.should raise_error(Whois::ResponseIsThrottled)

      i = Klass.new(Whois::Answer::Part.new("", "success.whois.test"))
      lambda { i.domain }.should_not raise_error
    end
  end

  context "property not supported" do
    it "raises Whois::ResponseIsThrottled when the response is throttled" do
      i = Klass.new(Whois::Answer::Part.new("", "throttled.whois.test"))
      lambda { i.domain_id }.should raise_error(Whois::PropertyNotSupported)

      i = Klass.new(Whois::Answer::Part.new("", "success.whois.test"))
      lambda { i.domain_id }.should raise_error(Whois::PropertyNotSupported)
    end
  end

end
