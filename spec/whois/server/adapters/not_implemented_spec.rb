require "spec_helper"

describe Whois::Server::Adapters::NotImplemented do

  before(:each) do
    @definition = [:ipv6, "2001:0000::/32", "teredo", { :adapter => Whois::Server::Adapters::NotImplemented }]
  end


  describe "#query" do
    it "raises Whois::ServerNotImplemented" do
      lambda do
        klass.new(*@definition).query("example.test")
      end.should raise_error(Whois::ServerNotImplemented)
    end

    it "customizes the error message according to the host" do
      lambda do
        klass.new(*@definition).query("example.test")
      end.should raise_error(Whois::ServerNotImplemented, /teredo/)
    end
  end

end
