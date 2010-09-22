require "spec_helper"

describe Whois::Client do

  before :each do
    @client = Whois::Client.new
  end

  context ".new" do
    it "should initialize" do
      client = Whois::Client.new
      client.should be_instance_of(Whois::Client)
    end

    it "should initialize with timeout" do
      client = Whois::Client.new(:timeout => 100)
      client.timeout.should == 100
    end

    it "should initialize with block" do
      Whois::Client.new do |client|
        client.should be_instance_of(Whois::Client)
      end
    end
  end

  context "#query" do
    it "should coerce qstring to string" do
      server = Object.new
      # I can't use the String because Array#to_s behaves differently
      # on Ruby 1.8.7 and Ruby 1.9.1
      # http://redmine.ruby-lang.org/issues/show/2617
      server.expects(:query).with(instance_of(String))
      Whois::Server.expects(:guess).with(instance_of(String)).returns(server)
      @client.query(["google", ".", "com"])
    end

    it "should detect email" do
      lambda { @client.query("weppos@weppos.net") }.should
        raise_error(Whois::ServerNotSupported)
    end

    it "should work with domain with no whois" do
      Whois::Server.define(:tld, ".nowhois", nil, :adapter => Whois::Server::Adapters::None)

      lambda { @client.query("domain.nowhois") }.should
        raise_error(Whois::NoInterfaceError, /no whois server/)
    end

    it "should work with domain with web whois" do
      Whois::Server.define(:tld, ".webwhois", nil, :adapter => Whois::Server::Adapters::Web, :web => "www.nic.test")

      lambda { @client.query("domain.webwhois") }.should raise_error(Whois::WebInterfaceError) do |error|
        error.message.should match(/no whois server/)
        error.message.should match(/www\.nic\.test/)
      end
    end

    it "should raise if timeout is exceeded" do
      server = Class.new do
        def query(*args)
          sleep(2)
        end
      end
      Whois::Server.expects(:guess).returns(server.new)
      @client.timeout = 1
      lambda { @client.query("foo.com") }.should raise_error(Timeout::Error)
    end

    it "should not raise if timeout is not exceeded" do
      server = Class.new do
        def query(*args)
          sleep(1)
        end
      end
      Whois::Server.expects(:guess).returns(server.new)
      @client.timeout = 5
      lambda { @client.query("foo.com") }.should_not raise_error
    end

    it "should support unlimited timeout" do
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

  need_connectivity do
    specify "#query with domain" do
      answer = @client.query("weppos.it")
      assert answer.match?(/Domain:\s+weppos\.it/)
      assert answer.match?(/Created:/)
    end
  end

end
