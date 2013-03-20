require 'spec_helper'

describe Whois::Server::Adapters::None do

  describe "#lookup" do
    it "raises Whois::NoInterfaceError" do
      expect {
        described_class.new(:tld, ".test", nil).lookup("example.test")
      }.to raise_error(Whois::NoInterfaceError)
    end

    it "customizes the error message according to the type" do
      expect {
        described_class.new(:tld, ".test", nil).lookup("example.test")
      }.to raise_error(Whois::NoInterfaceError, /tld/)

      expect {
        described_class.new(:ipv4, "127.0.0.1", nil).lookup("127.0.0.1")
      }.to raise_error(Whois::NoInterfaceError, /ipv4/)
    end
  end

end
