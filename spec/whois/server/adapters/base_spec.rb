require 'spec_helper'

describe Whois::Server::Adapters::Base do

  let(:definition)  { [:tld, ".test", "whois.test", { :foo => "bar" }] }


  describe "#initialize" do
    it "requires type, allocation, and host parameters" do
      expect { described_class.new(:tld) }.to raise_error(ArgumentError)
      expect { described_class.new(:tld, ".test") }.to raise_error(ArgumentError)
      expect { described_class.new(:tld, ".test", "whois.test") }.not_to raise_error
    end

    it "accepts an options parameter" do
      expect { described_class.new(:tld, ".test", "whois.test", { :foo => "bar" }) }.not_to raise_error
    end

    it "sets instance variables from arguments" do
      a = described_class.new(:tld, ".test", "whois.test", { :foo => "bar" })
      expect(a.type).to eq(:tld)
      expect(a.allocation).to eq(".test")
      expect(a.host).to eq("whois.test")
      expect(a.options).to eq({ :foo => "bar" })
    end

    it "defaults options to an empty hash" do
      a = described_class.new(:tld, ".test", "whois.test")
      expect(a.options).to eq(Hash.new)
    end
  end

  describe "#==" do
    it "returns true when other is the same instance" do
      one = two = described_class.new(*definition)

      expect(one == two).to be_truthy
      expect(one.eql? two).to be_truthy
    end

    it "returns true when other has same class and has the same attributes" do
      one, two = described_class.new(*definition), described_class.new(*definition)

      expect(one == two).to be_truthy
      expect(one.eql? two).to be_truthy
    end

    it "returns true when other has descendant class and has the same attributes" do
      subklass = Class.new(described_class)
      one, two = described_class.new(*definition), subklass.new(*definition)

      expect(one == two).to be_truthy
      expect(one.eql? two).to be_truthy
    end

    it "returns false when other has different class and has the same attributes" do
      one, two = described_class.new(*definition), Struct.new(:type, :allocation, :host, :options).new(*definition)

      expect(one == two).to be_falsey
      expect(one.eql? two).to be_falsey
    end

    it "returns false when other has different attributes" do
      one, two = described_class.new(:tld, ".test", "whois.test"), described_class.new(:tld, ".cool", "whois.test")

      expect(one == two).to be_falsey
      expect(one.eql? two).to be_falsey
    end

    it "returns false when other has different options" do
      one, two = described_class.new(:tld, ".test", "whois.test"), described_class.new(:tld, ".test", "whois.test", { :foo => "bar" })

      expect(one == two).to be_falsey
      expect(one.eql? two).to be_falsey
    end
  end


  describe "#configure" do
    it "merges settings with current options" do
      a = described_class.new(:tld, ".test", "whois.test", { :hello => "world" })
      a.configure(:foo => "bar")
      expect(a.options).to eq({ :hello => "world", :foo => "bar" })
    end

    it "gives higher priority to settings argument" do
      a = described_class.new(:tld, ".test", "whois.test", { :foo => "bar" })
      expect(a.options).to eq({ :foo => "bar" })
      a.configure(:foo => "baz")
      expect(a.options).to eq({ :foo => "baz" })
    end

    it "overrides @host if :host option exists" do
      a = described_class.new(:tld, ".test", "whois.test", { :hello => "world" })
      a.configure(:foo => "bar", :host => "whois.example.com")
      expect(a.options).to eq({ :hello => "world", :foo => "bar", :host => "whois.example.com" })
      expect(a.host).to eq("whois.example.com")
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
