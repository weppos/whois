require "spec_helper"

describe Whois::Client do

  context ".new" do
    it "initializes the instance" do
      client = klass.new
      client.should be_instance_of(klass)
    end

    it "accepts a timeout option" do
      client = klass.new(:timeout => 100)
      client.timeout.should == 100
    end

    it "accepts a block" do
      klass.new do |client|
        client.should be_instance_of(klass)
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
      klass.new.query(["google", ".", "com"])
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
      Whois::Server.define(:tld, ".webwhois", nil, :adapter => Whois::Server::Adapters::Web, :web => "www.nic.test")

      lambda do
        klass.new.query("domain.webwhois")
      end.should raise_error(Whois::WebInterfaceError, /www\.nic\.test/)
    end

    it "raises if timeout is exceeded" do
      server = Class.new do
        def query(*args)
          sleep(2)
        end
      end
      Whois::Server.expects(:guess).returns(server.new)

      client = klass.new(:timeout => 1)
      lambda { client.query("foo.com") }.should raise_error(Timeout::Error)
    end

    it "doesn't raise if timeout is not exceeded" do
      server = Class.new do
        def query(*args)
          sleep(1)
        end
      end
      Whois::Server.expects(:guess).returns(server.new)

      client = klass.new(:timeout => 5)
      lambda { client.query("foo.com") }.should_not raise_error
    end

    it "supports unlimited timeout" do
      server = Class.new do
        def query(*args)
          sleep(1)
        end
      end
      Whois::Server.expects(:guess).returns(server.new)

      client = klass.new.tap { |c| c.timeout = nil }
      lambda { client.query("foo.com") }.should_not raise_error
    end

  end

  # FIXME: use RSpec metadata
  need_connectivity do
    describe "#query" do
      it "sends a query for given domain" do
        answer = klass.new.query("weppos.it")
        assert answer.match?(/Domain:\s+weppos\.it/)
        assert answer.match?(/Created:/)
      end
    end
  end

end
