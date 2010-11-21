require "spec_helper"

describe Whois::Client do

  before(:each) do
    @client = Whois::Client.new
  end

  context ".new" do
    it "initializes the instance" do
      client = Whois::Client.new
      client.should be_instance_of(Whois::Client)
    end

    it "accepts a timeout option" do
      client = Whois::Client.new(:timeout => 100)
      client.timeout.should == 100
    end

    it "accepts a block" do
      Whois::Client.new do |client|
        client.should be_instance_of(Whois::Client)
      end
    end
  end

  context "#query" do
    it "coerces qstring to string" do
      server = Object.new
      # I can't use the String because Array#to_s behaves differently
      # on Ruby 1.8.7 and Ruby 1.9.1
      # http://redmine.ruby-lang.org/issues/show/2617
      server.expects(:query).with(instance_of(String))
      Whois::Server.expects(:guess).with(instance_of(String)).returns(server)
      @client.query(["google", ".", "com"])
    end

    it "detects email" do
      lambda do
        @client.query("weppos@weppos.net")
      end.should raise_error(Whois::ServerNotSupported)
    end

    it "works with domain with no whois" do
      Whois::Server.define(:tld, ".nowhois", nil, :adapter => Whois::Server::Adapters::None)

      lambda do
        @client.query("domain.nowhois")
      end.should raise_error(Whois::NoInterfaceError, /no whois server/)
    end

    it "works with domain with web whois" do
      Whois::Server.define(:tld, ".webwhois", nil, :adapter => Whois::Server::Adapters::Web, :web => "www.nic.test")

      lambda do
        @client.query("domain.webwhois")
      end.should raise_error(Whois::WebInterfaceError, /www\.nic\.test/)
    end

    it "raises if timeout is exceeded" do
      server = Class.new do
        def query(*args)
          sleep(2)
        end
      end
      Whois::Server.expects(:guess).returns(server.new)
      @client.timeout = 1
      lambda { @client.query("foo.com") }.should raise_error(Timeout::Error)
    end

    it "doesn't raise if timeout is not exceeded" do
      server = Class.new do
        def query(*args)
          sleep(1)
        end
      end
      Whois::Server.expects(:guess).returns(server.new)
      @client.timeout = 5
      lambda { @client.query("foo.com") }.should_not raise_error
    end

    it "supports unlimited timeout" do
      server = Class.new do
        def query(*args)
          sleep(1)
        end
      end
      Whois::Server.expects(:guess).returns(server.new)
      @client.timeout = nil
      lambda { @client.query("foo.com") }.should_not raise_error
    end

  end

  # FIXME: use RSpec metadata
  need_connectivity do
    describe "#query" do
      it "sends a query for given domain" do
        answer = @client.query("weppos.it")
        assert answer.match?(/Domain:\s+weppos\.it/)
        assert answer.match?(/Created:/)
      end
    end
  end

end
