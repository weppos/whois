require 'spec_helper'
require 'whois/record/nameserver'


describe Whois::Record::Nameserver do

  it "inherits from SuperStruct" do
    expect(described_class.ancestors).to include(SuperStruct)
  end


  describe "#initialize" do
    it "accepts an empty value" do
      expect {
        instance = described_class.new
        expect(instance.name).to be_nil
      }.to_not raise_error
    end

    it "accepts an empty hash" do
      expect {
        instance = described_class.new({})
        expect(instance.name).to be_nil
      }.to_not raise_error
    end

    it "initializes a new instance from given hash" do
      instance = described_class.new(:name => "ns1.example.com", :ipv4 => "127.0.0.1")

      expect(instance.name).to eq("ns1.example.com")
      expect(instance.ipv4).to eq("127.0.0.1")
      expect(instance.ipv6).to be_nil
    end

    it "initializes a new instance from given block" do
      instance = described_class.new do |c|
        c.name  = "ns1.example.com"
        c.ipv4  = "127.0.0.1"
      end

      expect(instance.name).to eq("ns1.example.com")
      expect(instance.ipv4).to eq("127.0.0.1")
      expect(instance.ipv6).to be_nil
    end
  end

  describe "#to_s" do
    it "returns the string representation of this object" do
      expect(described_class.new(name: "ns1.example.com").to_s).to eq("ns1.example.com")
      expect(described_class.new(name: nil).to_s).to eq("")
      expect(described_class.new.to_s).to eq("")
    end
  end

end
