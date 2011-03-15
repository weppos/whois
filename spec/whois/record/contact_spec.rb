require "spec_helper"

describe Whois::Record::Contact do

  it "inherits from SuperStruct" do
    klass.ancestors.should include(SuperStruct)
  end


  describe "#initialize" do
    it "accepts an empty value" do
      lambda do
        i = klass.new
        i.id.should be_nil
      end.should_not raise_error
    end

    it "accepts an empty hash" do
      lambda do
        i = klass.new({})
        i.id.should be_nil
      end.should_not raise_error
    end

    it "initializes a new instance from given params" do
      i = klass.new(10, klass::TYPE_REGISTRANT, "John Doe", nil)

      i.id.should == 10
      i.type.should == klass::TYPE_REGISTRANT
      i.name.should == "John Doe"
      i.organization.should be_nil
    end

    it "initializes a new instance from given hash" do
      i = klass.new(:id => 10, :name => "John Doe", :type => klass::TYPE_REGISTRANT)

      i.id.should == 10
      i.type.should == klass::TYPE_REGISTRANT
      i.name.should == "John Doe"
      i.organization.should be_nil
    end

    it "initializes a new instance from given block" do
      i = klass.new do |c|
        c.id    = 10
        c.type  = klass::TYPE_REGISTRANT
        c.name  = "John Doe"
      end

      i.id.should == 10
      i.type.should == klass::TYPE_REGISTRANT
      i.name.should == "John Doe"
      i.organization.should be_nil
    end
  end

end
