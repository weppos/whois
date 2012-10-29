require 'spec_helper'

describe Whois::Server::Adapters::NotImplemented do

  before(:each) do
    @definition = [:ipv6, "2001:0000::/32", "teredo", { :adapter => Whois::Server::Adapters::NotImplemented }]
  end


  describe "#lookup" do
    it "raises Whois::ServerNotImplemented" do
      expect {
        klass.new(*@definition).lookup("example.test")
      }.to raise_error(Whois::ServerNotImplemented)
    end

    it "customizes the error message according to the host" do
      expect {
        klass.new(*@definition).lookup("example.test")
      }.to raise_error(Whois::ServerNotImplemented, /teredo/)
    end
  end

end
