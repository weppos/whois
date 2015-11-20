require 'spec_helper'

describe SuperStruct do

  SuperEroe = Class.new(SuperStruct.new(:name, :supername))

  it "inherits from Struct" do
    expect(SuperEroe.ancestors).to include(Struct)
  end


  describe "#initialize" do
    it "initializes a new instance from given hash" do
      instance = SuperEroe.new(:name => "Pippo", :supername => "SuperPippo")
      expect(instance.name).to eq("Pippo")
      expect(instance.supername).to eq("SuperPippo")
    end

    it "initializes a new instance from given block" do
      SuperEroe.new do |instance|
        expect(instance).to be_instance_of(SuperEroe)
        expect(instance).to be_kind_of(SuperStruct)
      end
    end
  end

end
