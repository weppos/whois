require 'spec_helper'
require 'whois/record/registrar'


describe Whois::Record::Registrar do

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
    #   i = described_class.new(10, "John Doe", nil, "http://example.com")

    #   i.id.should == 10
    #   i.name.should == "John Doe"
    #   i.organization.should be_nil
    #   i.url.should == "http://example.com"
    # end

    it "initializes a new instance from given hash" do
      i = described_class.new(:id => 10, :name => "John Doe", :url => "http://example.com")

      expect(i.id).to eq(10)
      expect(i.name).to eq("John Doe")
      expect(i.organization).to be_nil
      expect(i.url).to eq("http://example.com")
    end

    it "initializes a new instance from given block" do
      i = described_class.new do |c|
        c.id    = 10
        c.name  = "John Doe"
        c.url   = "http://example.com"
      end

      expect(i.id).to eq(10)
      expect(i.name).to eq("John Doe")
      expect(i.organization).to be_nil
      expect(i.url).to eq("http://example.com")
    end
  end

end
