require 'spec_helper'

describe Whois::Record::Part do

  it "inherits from SuperStruct" do
    expect(described_class.ancestors).to include(SuperStruct)
  end


  describe "#initialize" do
    it "accepts an empty value" do
      expect do
        i = described_class.new
        expect(i.body).to be_nil
      end.not_to raise_error
    end

    it "accepts an empty hash" do
      expect do
        i = described_class.new({})
        expect(i.body).to be_nil
      end.not_to raise_error
    end

    # it "initializes a new instance from given params" do
    #   i = described_class.new("This is a WHOIS record.", "whois.example.test")

    #   i.body.should == "This is a WHOIS record."
    #   i.host.should == "whois.example.test"
    # end

    it "initializes a new instance from given hash" do
      i = described_class.new(:body => "This is a WHOIS record.", :host => "whois.example.test")

      expect(i.body).to eq("This is a WHOIS record.")
      expect(i.host).to eq("whois.example.test")
    end

    it "initializes a new instance from given block" do
      i = described_class.new do |c|
        c.body  = "This is a WHOIS record."
        c.host  = "whois.example.test"
      end

      expect(i.body).to eq("This is a WHOIS record.")
      expect(i.host).to eq("whois.example.test")
    end
  end

end
