require 'spec_helper'

describe SuperStruct do

  SuperEroe = Class.new(SuperStruct.new(:name, :supername))

  it "inherits from Struct" do
    SuperEroe.ancestors.should include(Struct)
  end


  describe "#initialize" do
    it "initializes a new instance from given hash" do
      i = SuperEroe.new(:name => "Pippo", :supername => "SuperPippo")
      i.name.should == "Pippo"
      i.supername.should == "SuperPippo"
    end

    it "initializes a new instance from given block" do
      SuperEroe.new do |i|
        i.should be_instance_of(SuperEroe)
        i.should be_kind_of(SuperStruct)
      end
    end
  end

end
