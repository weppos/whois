require "spec_helper"

describe Whois::Record::Part do

  it "inherits from SuperStruct" do
    klass.ancestors.should include(SuperStruct)
  end


  describe "#initialize" do
    it "accepts an empty value" do
      lambda do
        i = klass.new
        i.body.should be_nil
      end.should_not raise_error
    end

    it "accepts an empty hash" do
      lambda do
        i = klass.new({})
        i.body.should be_nil
      end.should_not raise_error
    end

    it "initializes a new instance from given params" do
      i = klass.new("This is a WHOIS record.", "whois.example.test")

      i.body.should == "This is a WHOIS record."
      i.host.should == "whois.example.test"
    end

    it "initializes a new instance from given hash" do
      i = klass.new(:body => "This is a WHOIS record.", :host => "whois.example.test")

      i.body.should == "This is a WHOIS record."
      i.host.should == "whois.example.test"
    end

    it "initializes a new instance from given block" do
      i = klass.new do |c|
        c.body  = "This is a WHOIS record."
        c.host  = "whois.example.test"
      end

      i.body.should == "This is a WHOIS record."
      i.host.should == "whois.example.test"
    end
  end

end
