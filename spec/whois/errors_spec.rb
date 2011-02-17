require "spec_helper"

describe Whois::WebInterfaceError do

  describe "#initialize" do
    it "sets the URL" do
      klass.new("http://example.com").url.should == "http://example.com"
    end

    it "requires the URL argument" do
      lambda { klass.new }.should raise_error(ArgumentError)
    end
  end

  describe "#message" do
    it "interpolates the URL" do
      klass.new("http://example.com").message.should match(%r{http://example.com})
    end
  end

end
