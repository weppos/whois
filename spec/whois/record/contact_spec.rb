require 'spec_helper'
require 'whois/record/contact'


describe Whois::Record::Contact do

  it "inherits from SuperStruct" do
    expect(described_class.ancestors).to include(SuperStruct)
  end


  describe "#initialize" do
    it "accepts an empty value" do
      expect do
        i = described_class.new
        expect(i.id).to be_nil
      end.not_to raise_error
    end

    it "accepts an empty hash" do
      expect do
        i = described_class.new({})
        expect(i.id).to be_nil
      end.not_to raise_error
    end

    # it "initializes a new instance from given params" do
    #   i = described_class.new(10, described_class::TYPE_REGISTRANT, "John Doe", nil)

    #   i.id.should == 10
    #   i.type.should == described_class::TYPE_REGISTRANT
    #   i.name.should == "John Doe"
    #   i.organization.should be_nil
    # end

    it "initializes a new instance from given hash" do
      i = described_class.new(:id => 10, :name => "John Doe", :type => described_class::TYPE_REGISTRANT)

      expect(i.id).to eq(10)
      expect(i.type).to eq(described_class::TYPE_REGISTRANT)
      expect(i.name).to eq("John Doe")
      expect(i.organization).to be_nil
    end

    it "initializes a new instance from given block" do
      i = described_class.new do |c|
        c.id    = 10
        c.type  = described_class::TYPE_REGISTRANT
        c.name  = "John Doe"
      end

      expect(i.id).to eq(10)
      expect(i.type).to eq(described_class::TYPE_REGISTRANT)
      expect(i.name).to eq("John Doe")
      expect(i.organization).to be_nil
    end
  end

end
