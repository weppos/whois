require 'spec_helper'

describe Whois::Server::Adapters::Web do

  before(:each) do
    @definition = [:tld, ".test", nil, { :url => "http://whois.test" }]
  end


  describe "#lookup" do
    it "raises Whois::WebInterfaceError" do
      expect {
        described_class.new(*@definition).lookup("example.test")
      }.to raise_error(Whois::WebInterfaceError)
    end

    it "customizes the error message with the WHOIS web url" do
      expect {
        described_class.new(*@definition).lookup("example.test")
      }.to raise_error(Whois::WebInterfaceError, /whois\.test/)
    end
  end

end
