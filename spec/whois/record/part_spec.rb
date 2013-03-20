require 'spec_helper'

describe Whois::Record::Part do

  it "inherits from SuperStruct" do
    described_class.ancestors.should include(SuperStruct)
  end


  describe "#initialize" do
    it "accepts an empty value" do
      lambda do
        i = described_class.new
        i.body.should be_nil
      end.should_not raise_error
    end

    it "accepts an empty hash" do
      lambda do
        i = described_class.new({})
        i.body.should be_nil
      end.should_not raise_error
    end

    # it "initializes a new instance from given params" do
    #   i = described_class.new("This is a WHOIS record.", "whois.example.test")

    #   i.body.should == "This is a WHOIS record."
    #   i.host.should == "whois.example.test"
    # end

    it "initializes a new instance from given hash" do
      i = described_class.new(:body => "This is a WHOIS record.", :host => "whois.example.test")

      i.body.should == "This is a WHOIS record."
      i.host.should == "whois.example.test"
    end

    it "initializes a new instance from given block" do
      i = described_class.new do |c|
        c.body  = "This is a WHOIS record."
        c.host  = "whois.example.test"
      end

      i.body.should == "This is a WHOIS record."
      i.host.should == "whois.example.test"
    end
  end

end
