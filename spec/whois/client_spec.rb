require "spec_helper"

describe Whois::Client do

  describe "#initialize" do
    it "accepts a zero parameters" do
      lambda { klass.new }.should_not raise_error
    end

    it "accepts a settings parameter" do
      lambda { klass.new({ :foo => "bar" }) }.should_not raise_error
    end


    it "accepts a timeout setting with a value in seconds" do
      client = klass.new(:timeout => 100)
      client.timeout.should == 100
    end

    it "accepts a timeout setting with a nil value" do
      client = klass.new(:timeout => nil)
      client.timeout.should be_nil
    end

    it "accepts a block" do
      klass.new do |client|
        client.should be_instance_of(klass)
      end
    end


    it "defaults timeout setting to DEFAULT_TIMEOUT" do
      client = klass.new
      client.timeout.should == klass::DEFAULT_TIMEOUT
    end

    it "sets settings to given argument, except timeout" do
      client = klass.new(:timeout => nil, :foo => "bar")
      client.settings.should == { :foo => "bar" }
    end
  end

  describe "#query" do
    it "converts the argument to string" do
      # I can't use the String in place of instance_of(String)
      # because Array#to_s behaves differently
      # on Ruby 1.8.7 and Ruby 1.9.1
      # http://redmine.ruby-lang.org/issues/show/2617

      server = Whois::Server::Adapters::Base.new(:tld, ".test", "whois.test")
      server.expects(:query).with(instance_of(String))
      Whois::Server.expects(:guess).with(instance_of(String)).returns(server)
      klass.new.query(["example", ".", "test"])
    end

    it "converts the argument to downcase" do
      server = Whois::Server::Adapters::Base.new(:tld, ".test", "whois.test")
      server.expects(:query).with("example.test")
      Whois::Server.expects(:guess).with("example.test").returns(server)
      klass.new.query("Example.TEST")
    end

    it "detects email" do
      lambda do
        klass.new.query("weppos@weppos.net")
      end.should raise_error(Whois::ServerNotSupported)
    end

    it "works with domain with no whois" do
      Whois::Server.define(:tld, ".nowhois", nil, :adapter => Whois::Server::Adapters::None)

      lambda do
        klass.new.query("domain.nowhois")
      end.should raise_error(Whois::NoInterfaceError, /no whois server/)
    end

    it "works with domain with web whois" do
      Whois::Server.define(:tld, ".webwhois", nil, :adapter => Whois::Server::Adapters::Web, :url => "http://www.example.com/")

      lambda do
        klass.new.query("domain.webwhois")
      end.should raise_error(Whois::WebInterfaceError, /www\.example\.com/)
    end

    it "raises if timeout is exceeded" do
      adapter = Class.new(Whois::Server::Adapters::Base) do
        def query(*args)
          sleep(2)
        end
      end
      Whois::Server.expects(:guess).returns(adapter.new(:tld, ".test", "whois.test"))

      client = klass.new(:timeout => 1)
      lambda { client.query("example.test") }.should raise_error(Timeout::Error)
    end

    it "does not raise if timeout is not exceeded" do
      adapter = Class.new(Whois::Server::Adapters::Base) do
        def query(*args)
          sleep(1)
        end
      end
      Whois::Server.expects(:guess).returns(adapter.new(:tld, ".test", "whois.test"))

      client = klass.new(:timeout => 5)
      lambda { client.query("example.test") }.should_not raise_error
    end

    it "supports unlimited timeout" do
      adapter = Class.new(Whois::Server::Adapters::Base) do
        def query(*args)
          sleep(1)
        end
      end
      Whois::Server.expects(:guess).returns(adapter.new(:tld, ".test", "whois.test"))

      client = klass.new.tap { |c| c.timeout = nil }
      lambda { client.query("example.test") }.should_not raise_error
    end

  end

  # FIXME: use RSpec metadata
  need_connectivity do
    describe "#query" do
      it "sends a query for given domain" do
        record = klass.new.query("weppos.it")
        assert record.match?(/Domain:\s+weppos\.it/)
        assert record.match?(/Created:/)
      end
    end
  end

end
