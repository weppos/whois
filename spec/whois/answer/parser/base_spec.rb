require "spec_helper"

describe Whois::Answer::Parser::Base do

  before(:each) do
    @part = Whois::Answer::Part.new("This is the response.", "whois.example.test")
  end


  describe ".property_registry" do
    it "returns the @@registry variable when no argument is passed" do
      with_registry do
        klass.property_registry.should == klass.send(:class_variable_get, :@@property_registry)
      end
    end

    it "returns the hash for given class when class argument is passed" do
      with_registry do
        test_parser = Class.new(klass)
        klass.send(:class_variable_set, :@@property_registry, { test_parser => {} })

        klass.property_registry[test_parser].should == Hash.new
      end
    end

    it "lazy initializes the hash for given class" do
      with_registry do
        test_parser = Class.new(klass)
        klass.send(:class_variable_set, :@@property_registry, Hash.new)
        klass.property_registry[test_parser]
        klass.send(:class_variable_get, :@@property_registry).should == {}
      end
    end
  end

  describe "#property_supported?" do
    it "returns false if the property is not supported" do
      pclass = Class.new(klass) do
      end
      pclass.new(@part).property_supported?(:disclaimer).should be_false
      pclass.new(@part).respond_to?(:disclaimer).should be_true
    end

    it "returns true if the property is supported" do
      pclass = Class.new(klass) do
        register_property(:disclaimer, :supported) {}
      end
      pclass.new(@part).property_supported?(:disclaimer).should be_true
      pclass.new(@part).respond_to?(:disclaimer).should be_true
    end
  end


  describe ".new" do
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
      instance = klass.new(@part)
      instance.content.should be(@part.body)
    end
  end

  describe "#content_for_scanner" do
    it "returns the part body with line feed normalized" do
      instance = klass.new(Whois::Answer::Part.new("This is\r\nthe response.", "whois.example.test"))
      instance.send(:content_for_scanner).should == "This is\nthe response."
    end

    it "caches the result" do
      instance = klass.new(Whois::Answer::Part.new("This is\r\nthe response.", "whois.example.test"))
      instance.instance_eval { @content_for_scanner }.should be_nil
      instance.send(:content_for_scanner)
      instance.instance_eval { @content_for_scanner }.should == "This is\nthe response."
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
      instance = klass.new(@part)
      instance.unchanged?(instance).should be_true
    end

    it "returns true if the content_for_scanner is the same" do
      instance = klass.new(Whois::Answer::Part.new("This is the\nresponse 1.", "whois.example.test"))
      other    = klass.new(Whois::Answer::Part.new("This is the\r\nresponse 1.", "whois.example.test"))
      instance.unchanged?(other).should be_true
    end

    it "returns false if the content_for_scanner is not the same" do
      instance = klass.new(Whois::Answer::Part.new("This is the response 1.", "whois.example.test"))
      other    = klass.new(Whois::Answer::Part.new("This is the response 2.", "whois.example.test"))
      instance.unchanged?(other).should be_false
    end
  end

  describe "#contacts" do
    it "returns an array of contacts" do
      c1 = Whois::Answer::Contact.new(:id => "1st", :name => "foo")
      c2 = Whois::Answer::Contact.new(:id => "2nd", :name => "foo")
      c3 = Whois::Answer::Contact.new(:id => "3rd", :name => "foo")
      pclass = Class.new(klass) do
        register_property(:registrant_contact, :supported) { [c1, c2] }
        register_property(:admin_contact, :supported) { nil }
        register_property(:technical_contact, :supported) { c3 }
      end

      instance = pclass.new(@part)
      instance.contacts.should == [c1, c2, c3]
    end

    it "returns an empty array when no contact is supported" do
      instance = klass.new(@part)
      instance.contacts.should == []
    end
  end

  describe "#throttle?" do
    it "returns false" do
      instance = klass.new(@part)
      instance.throttle?.should be_false
    end
  end

end
