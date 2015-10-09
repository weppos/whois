require 'spec_helper'
require 'whois/record/registrar'


describe Whois::Record::Registrar do

  it "inherits from SuperStruct" do
    expect(described_class.ancestors).to include(SuperStruct)
  end


  describe "#initialize" do
    it "accepts an empty value" do
      expect {
        instance = described_class.new
        expect(instance.id).to be_nil
      }.to_not raise_error
    end

    it "accepts an empty hash" do
      expect {
        instance = described_class.new({})
        expect(instance.id).to be_nil
      }.to_not raise_error
    end

    it "initializes a new instance from given hash" do
      instance = described_class.new(:id => 10, :name => "John Doe", :url => "http://example.com")

      expect(instance.id).to eq(10)
      expect(instance.name).to eq("John Doe")
      expect(instance.organization).to be_nil
      expect(instance.url).to eq("http://example.com")
    end

    it "initializes a new instance from given block" do
      instance = described_class.new do |c|
        c.id    = 10
        c.name  = "John Doe"
        c.url   = "http://example.com"
      end

      expect(instance.id).to eq(10)
      expect(instance.name).to eq("John Doe")
      expect(instance.organization).to be_nil
      expect(instance.url).to eq("http://example.com")
    end
  end

end
