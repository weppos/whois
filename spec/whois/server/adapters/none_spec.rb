require "spec_helper"

describe Whois::Server::Adapters::None do

  describe "#query" do
    it "raises Whois::NoInterfaceError" do
      lambda do
        klass.new(:tld, ".test", nil).query("example.test")
      end.should raise_error(Whois::NoInterfaceError)
    end

    it "customizes the error message according to the type" do
      lambda do
        klass.new(:tld, ".test", nil).query("example.test")
      end.should raise_error(Whois::NoInterfaceError, /tld/)
      lambda do
        klass.new(:ipv4, "127.0.0.1", nil).query("127.0.0.1")
      end.should raise_error(Whois::NoInterfaceError, /ipv4/)
    end
  end

end
