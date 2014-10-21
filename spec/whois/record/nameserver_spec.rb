require 'spec_helper'
require 'whois/record/nameserver'


describe Whois::Record::Nameserver do

  it "inherits from SuperStruct" do
    expect(described_class.ancestors).to include(SuperStruct)
  end


  describe "#initialize" do
    it "accepts an empty value" do
      expect do
        i = described_class.new
        expect(i.name).to be_nil
      end.not_to raise_error
    end

    it "accepts an empty hash" do
      expect do
        i = described_class.new({})
        expect(i.name).to be_nil
      end.not_to raise_error
    end

    # it "initializes a new instance from given params" do
    #   i = described_class.new("ns1.example.com", "127.0.0.1")

    #   i.name.should == "ns1.example.com"
    #   i.ipv4.should == "127.0.0.1"
    #   i.ipv6.should be_nil
    # end

    it "initializes a new instance from given hash" do
      i = described_class.new(:name => "ns1.example.com", :ipv4 => "127.0.0.1")

      expect(i.name).to eq("ns1.example.com")
      expect(i.ipv4).to eq("127.0.0.1")
      expect(i.ipv6).to be_nil
    end

    it "initializes a new instance from given block" do
      i = described_class.new do |c|
        c.name  = "ns1.example.com"
        c.ipv4  = "127.0.0.1"
      end

      expect(i.name).to eq("ns1.example.com")
      expect(i.ipv4).to eq("127.0.0.1")
      expect(i.ipv6).to be_nil
    end
  end

  describe "#to_s" do
    it "returns the string representation of this object" do
      expect(described_class.new(:name => "ns1.example.com").to_s).to eq("ns1.example.com")
      expect(described_class.new(:name => nil).to_s).to eq("")
      expect(described_class.new.to_s).to eq("")
    end
  end

end
