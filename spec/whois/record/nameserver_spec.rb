require 'spec_helper'
require 'whois/record/nameserver'


describe Whois::Record::Nameserver do

  it "inherits from SuperStruct" do
    described_class.ancestors.should include(SuperStruct)
  end


  describe "#initialize" do
    it "accepts an empty value" do
      lambda do
        i = described_class.new
        i.name.should be_nil
      end.should_not raise_error
    end

    it "accepts an empty hash" do
      lambda do
        i = described_class.new({})
        i.name.should be_nil
      end.should_not raise_error
    end

    # it "initializes a new instance from given params" do
    #   i = described_class.new("ns1.example.com", "127.0.0.1")

    #   i.name.should == "ns1.example.com"
    #   i.ipv4.should == "127.0.0.1"
    #   i.ipv6.should be_nil
    # end

    it "initializes a new instance from given hash" do
      i = described_class.new(:name => "ns1.example.com", :ipv4 => "127.0.0.1")

      i.name.should == "ns1.example.com"
      i.ipv4.should == "127.0.0.1"
      i.ipv6.should be_nil
    end

    it "initializes a new instance from given block" do
      i = described_class.new do |c|
        c.name  = "ns1.example.com"
        c.ipv4  = "127.0.0.1"
      end

      i.name.should == "ns1.example.com"
      i.ipv4.should == "127.0.0.1"
      i.ipv6.should be_nil
    end
  end

  describe "#to_s" do
    it "returns the string representation of this object" do
      described_class.new(:name => "ns1.example.com").to_s.should == "ns1.example.com"
      described_class.new(:name => nil).to_s.should == ""
      described_class.new.to_s.should == ""
    end
  end

end
