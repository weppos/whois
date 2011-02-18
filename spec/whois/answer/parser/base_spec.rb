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
        pklass.public_instance_methods.should_not include(:greetings)
        pklass.property_register(:greetings, :supported) {}
        pklass.public_instance_methods.should include(:greetings)

        pklass = Class.new(klass)
        pklass.public_instance_methods.should_not include(:greetings)
        pklass.property_register(:greetings, :supported)
        pklass.public_instance_methods.should_not include(:greetings)
      end
    end

    it "defines a private method called internal_PROPERTY when block is given" do
      with_registry do
        pklass = Class.new(klass)
        pklass.private_instance_methods.should_not include(:internal_greetings)
        pklass.property_register(:greetings, :supported) {}
        pklass.private_instance_methods.should include(:internal_greetings)

        pklass = Class.new(klass)
        pklass.private_instance_methods.should_not include(:internal_greetings)
        pklass.property_register(:greetings, :supported)
        pklass.private_instance_methods.should_not include(:internal_greetings)
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
      k = Class.new(klass) do
        property_register(:registrant_contact, :supported) { [c1, c2] }
        property_register(:admin_contact, :supported) { nil }
        property_register(:technical_contact, :supported) { c3 }
      end

      i = k.new(@part)
      i.contacts.should == [c1, c2, c3]
    end

    it "returns an empty array when no contact is supported" do
      i = klass.new(@part)
      i.contacts.should == []
    end
  end


  describe "#throttle?" do
    it "is undefined" do
      klass.new(@part).respond_to?(:throttle?).should be_false
    end

    # it "returns nil" do
    #   i = klass.new(@part)
    #   i.throttle?.should be_nil
    # end
    #
    # it "is false" do
    #   i = klass.new(@part)
    #   i.throttle?.should be_false
    # end
  end

  describe "#incomplete?" do
    it "is undefined" do
      klass.new(@part).respond_to?(:incomplete?).should be_false
    end

    # it "returns nil" do
    #   i = klass.new(@part)
    #   i.incomplete?.should be_nil
    # end
    #
    # it "is false" do
    #   i = klass.new(@part)
    #   i.incomplete?.should be_false
    # end
  end

end
