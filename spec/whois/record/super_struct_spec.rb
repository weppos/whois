require 'spec_helper'

describe SuperStruct do

  SuperEroe = Class.new(SuperStruct.new(:name, :supername))

  it "inherits from Struct" do
    expect(SuperEroe.ancestors).to include(Struct)
  end


  describe "#initialize" do
    it "initializes a new instance from given hash" do
      i = SuperEroe.new(:name => "Pippo", :supername => "SuperPippo")
      expect(i.name).to eq("Pippo")
      expect(i.supername).to eq("SuperPippo")
    end

    it "initializes a new instance from given block" do
      SuperEroe.new do |i|
        expect(i).to be_instance_of(SuperEroe)
        expect(i).to be_kind_of(SuperStruct)
      end
    end
  end

end
