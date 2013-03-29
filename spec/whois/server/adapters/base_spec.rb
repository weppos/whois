require 'spec_helper'

describe Whois::Server::Adapters::Base do

  let(:definition)  { [:tld, ".test", "whois.test", { :foo => "bar" }] }


  describe "#initialize" do
    it "requires type, allocation, and host parameters" do
      lambda { described_class.new(:tld) }.should raise_error(ArgumentError)
      lambda { described_class.new(:tld, ".test") }.should raise_error(ArgumentError)
      lambda { described_class.new(:tld, ".test", "whois.test") }.should_not raise_error
    end

    it "accepts an options parameter" do
      lambda { described_class.new(:tld, ".test", "whois.test", { :foo => "bar" }) }.should_not raise_error
    end

    it "sets instance variables from arguments" do
      a = described_class.new(:tld, ".test", "whois.test", { :foo => "bar" })
      a.type.should == :tld
      a.allocation.should == ".test"
      a.host.should == "whois.test"
      a.options.should == { :foo => "bar" }
    end

    it "defaults options to an empty hash" do
      a = described_class.new(:tld, ".test", "whois.test")
      a.options.should == Hash.new
    end
  end

  describe "#==" do
    it "returns true when other is the same instance" do
      one = two = described_class.new(*definition)

      (one == two).should be_true
      (one.eql? two).should be_true
    end

    it "returns true when other has same class and has the same attributes" do
      one, two = described_class.new(*definition), described_class.new(*definition)

      (one == two).should be_true
      (one.eql? two).should be_true
    end

    it "returns true when other has descendant class and has the same attributes" do
      subklass = Class.new(described_class)
      one, two = described_class.new(*definition), subklass.new(*definition)

      (one == two).should be_true
      (one.eql? two).should be_true
    end

    it "returns false when other has different class and has the same attributes" do
      one, two = described_class.new(*definition), Struct.new(:type, :allocation, :host, :options).new(*definition)

      (one == two).should be_false
      (one.eql? two).should be_false
    end

    it "returns false when other has different attributes" do
      one, two = described_class.new(:tld, ".test", "whois.test"), described_class.new(:tld, ".cool", "whois.test")

      (one == two).should be_false
      (one.eql? two).should be_false
    end

    it "returns false when other has different options" do
      one, two = described_class.new(:tld, ".test", "whois.test"), described_class.new(:tld, ".test", "whois.test", { :foo => "bar" })

      (one == two).should be_false
      (one.eql? two).should be_false
    end
  end


  describe "#configure" do
    it "merges settings with current options" do
      a = described_class.new(:tld, ".test", "whois.test", { :hello => "world" })
      a.configure(:foo => "bar")
      a.options.should == { :hello => "world", :foo => "bar" }
    end

    it "gives higher priority to settings argument" do
      a = described_class.new(:tld, ".test", "whois.test", { :foo => "bar" })
      a.options.should == { :foo => "bar" }
      a.configure(:foo => "baz")
      a.options.should == { :foo => "baz" }
    end

    it "overrides @host if :host option exists" do
      a = described_class.new(:tld, ".test", "whois.test", { :hello => "world" })
      a.configure(:foo => "bar", :host => "whois.example.com")
      a.options.should == { :hello => "world", :foo => "bar", :host => "whois.example.com" }
      a.host.should == "whois.example.com"
    end
  end


  describe "#lookup" do
    it "raises NotImplementedError" do
      expect {
        described_class.new(*definition).lookup("example.test")
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#request" do
    it "is an abstract method" do
      expect {
        described_class.new(*definition).request("example.test")
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#query_the_socket" do
    context "without :bind_host or :bind_port options" do
      let(:server) { described_class.new(:tld, ".test", "whois.test", {}) }

      it "does not bind the WHOIS query" do
        described_class.
            query_handler.expects(:call).
            with("example.test", "whois.test", 43)

        server.send(:query_the_socket, "example.test", "whois.test", 43)
      end
    end

    context "with :bind_host and :bind_port options" do
      let(:server) { described_class.new(:tld, ".test", "whois.test", { :bind_host => "192.168.1.1", :bind_port => 3000 }) }

      it "binds the WHOIS query to given host and port" do
        described_class.
            query_handler.expects(:call).
            with("example.test", "whois.test", 43, "192.168.1.1", 3000)

        server.send(:query_the_socket, "example.test", "whois.test", 43)
      end
    end

    context "with :bind_port and without :bind_host options" do
      let(:server) { described_class.new(:tld, ".test", "whois.test", { :bind_port => 3000 }) }

      it "binds the WHOIS query to given port and defaults host" do
        described_class.
            query_handler.expects(:call).
            with("example.test", "whois.test", 43, described_class::DEFAULT_BIND_HOST, 3000)

        server.send(:query_the_socket, "example.test", "whois.test", 43)
      end
    end
  end

end
