require 'spec_helper'

describe Whois::Client do

  describe "#initialize" do
    it "accepts a zero parameters" do
      lambda { described_class.new }.should_not raise_error
    end

    it "accepts a settings parameter" do
      lambda { described_class.new({ :foo => "bar" }) }.should_not raise_error
    end


    it "accepts a timeout setting with a value in seconds" do
      client = described_class.new(:timeout => 100)
      client.timeout.should == 100
    end

    it "accepts a timeout setting with a nil value" do
      client = described_class.new(:timeout => nil)
      client.timeout.should be_nil
    end

    it "accepts a block" do
      described_class.new do |client|
        client.should be_instance_of(described_class)
      end
    end


    it "defaults timeout setting to DEFAULT_TIMEOUT" do
      client = described_class.new
      client.timeout.should == described_class::DEFAULT_TIMEOUT
    end

    it "sets settings to given argument, except timeout" do
      client = described_class.new(:timeout => nil, :foo => "bar")
      client.settings.should == { :foo => "bar" }
    end
  end

  describe "#lookup" do
    it "converts the argument to string" do
      query = ["example", ".", "test"]
      query.instance_eval do
        def to_s
          join
        end
      end

      server = Whois::Server::Adapters::Base.new(:tld, ".test", "whois.test")
      server.expects(:lookup).with("example.test")
      Whois::Server.expects(:guess).with("example.test").returns(server)

      described_class.new.lookup(query)
    end

    it "converts the argument to downcase" do
      server = Whois::Server::Adapters::Base.new(:tld, ".test", "whois.test")
      server.expects(:lookup).with("example.test")
      Whois::Server.expects(:guess).with("example.test").returns(server)

      described_class.new.lookup("Example.TEST")
    end

    it "detects email" do
      expect {
        described_class.new.lookup("weppos@weppos.net")
      }.to raise_error(Whois::ServerNotSupported)
    end

    it "works with domain with no whois" do
      Whois::Server.define(:tld, ".nowhois", nil, :adapter => Whois::Server::Adapters::None)

      expect {
        described_class.new.lookup("domain.nowhois")
      }.to raise_error(Whois::NoInterfaceError, /no whois server/)
    end

    it "works with domain with web whois" do
      Whois::Server.define(:tld, ".webwhois", nil, :adapter => Whois::Server::Adapters::Web, :url => "http://www.example.com/")

      expect {
        described_class.new.lookup("domain.webwhois")
      }.to raise_error(Whois::WebInterfaceError, /www\.example\.com/)
    end

    it "raises if timeout is exceeded" do
      adapter = Class.new(Whois::Server::Adapters::Base) do
        def lookup(*)
          sleep(2)
        end
      end
      Whois::Server.expects(:guess).returns(adapter.new(:tld, ".test", "whois.test"))

      client = described_class.new(:timeout => 1)
      expect {
        client.lookup("example.test")
      }.to raise_error(Timeout::Error)
    end

    it "does not raise if timeout is not exceeded" do
      adapter = Class.new(Whois::Server::Adapters::Base) do
        def lookup(*)
          sleep(1)
        end
      end
      Whois::Server.expects(:guess).returns(adapter.new(:tld, ".test", "whois.test"))

      client = described_class.new(:timeout => 5)
      expect {
        client.lookup("example.test")
      }.to_not raise_error
    end

    it "supports unlimited timeout" do
      adapter = Class.new(Whois::Server::Adapters::Base) do
        def lookup(*)
          sleep(1)
        end
      end
      Whois::Server.expects(:guess).returns(adapter.new(:tld, ".test", "whois.test"))

      client = described_class.new.tap { |c| c.timeout = nil }
      expect {
        client.lookup("example.test")
      }.to_not raise_error
    end

  end

  # FIXME: use RSpec metadata
  need_connectivity do
    describe "#query" do
      it "sends a query for given domain" do
        record = described_class.new.lookup("weppos.it")
        assert record.match?(/Domain:\s+weppos\.it/)
        assert record.match?(/Created:/)
      end
    end
  end

end
