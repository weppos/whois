require 'spec_helper'
require 'whois/record/registrar'


describe Whois::Record::Registrar do

  it "inherits from SuperStruct" do
    described_class.ancestors.should include(SuperStruct)
  end


  describe "#initialize" do
    it "accepts an empty value" do
      lambda do
        i = described_class.new
        i.id.should be_nil
      end.should_not raise_error
    end

    it "accepts an empty hash" do
      lambda do
        i = described_class.new({})
        i.id.should be_nil
      end.should_not raise_error
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

      i.id.should == 10
      i.name.should == "John Doe"
      i.organization.should be_nil
      i.url.should == "http://example.com"
    end

    it "initializes a new instance from given block" do
      i = described_class.new do |c|
        c.id    = 10
        c.name  = "John Doe"
        c.url   = "http://example.com"
      end

      i.id.should == 10
      i.name.should == "John Doe"
      i.organization.should be_nil
      i.url.should == "http://example.com"
    end
  end

end
