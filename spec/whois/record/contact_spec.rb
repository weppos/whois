require 'spec_helper'
require 'whois/record/contact'


describe Whois::Record::Contact do

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
      instance = described_class.new(:id => 10, :name => "John Doe", :type => described_class::TYPE_REGISTRANT)

      expect(instance.id).to eq(10)
      expect(instance.type).to eq(described_class::TYPE_REGISTRANT)
      expect(instance.name).to eq("John Doe")
      expect(instance.organization).to be_nil
    end

    it "initializes a new instance from given block" do
      inspect = described_class.new do |c|
        c.id    = 10
        c.type  = described_class::TYPE_REGISTRANT
        c.name  = "John Doe"
      end

      expect(inspect.id).to eq(10)
      expect(inspect.type).to eq(described_class::TYPE_REGISTRANT)
      expect(inspect.name).to eq("John Doe")
      expect(inspect.organization).to be_nil
    end
  end

end

