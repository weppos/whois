require 'spec_helper'

describe Whois::Record::Part do

  describe "#initialize" do
    it "accepts an empty value" do
      expect {
        instance = described_class.new
        expect(instance.body).to be_nil
      }.to_not raise_error
    end

    it "accepts an empty hash" do
      expect {
        instance = described_class.new({})
        expect(instance.body).to be_nil
      }.to_not raise_error
    end

    it "initializes a new instance from given hash" do
      instance = described_class.new(body: "This is a WHOIS record.", host: "whois.example.test")

      expect(instance.body).to eq("This is a WHOIS record.")
      expect(instance.host).to eq("whois.example.test")
    end

    it "initializes a new instance from given block" do
      instance = described_class.new do |c|
        c.body  = "This is a WHOIS record."
        c.host  = "whois.example.test"
      end

      expect(instance.body).to eq("This is a WHOIS record.")
      expect(instance.host).to eq("whois.example.test")
    end
  end

end
