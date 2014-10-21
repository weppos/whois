require 'spec_helper'

describe Whois::WebInterfaceError do

  describe "#initialize" do
    it "sets the URL" do
      expect(described_class.new("http://example.com").url).to eq("http://example.com")
    end

    it "requires the URL argument" do
      expect {
        described_class.new
      }.to raise_error(ArgumentError)
    end
  end

  describe "#message" do
    it "interpolates the URL" do
      expect(described_class.new("http://example.com").message).to match(%r{http://example.com})
    end
  end

end
