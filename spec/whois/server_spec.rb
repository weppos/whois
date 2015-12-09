require 'spec_helper'

describe Whois::Server do
  describe ".load_json" do
    it "loads a definition from a JSON file" do
      expect(File).to receive(:read).with("tld.json").and_return(<<-JSON)
{
  ".ae.org": {
    "host": "whois.centralnic.com"
  },
  ".ar.com": {
    "host": "whois.centralnic.com"
  }
}
      JSON
      with_definitions do
        described_class.load_json("tld.json")
        expect(described_class.definitions(:tld)).to eq([
          [".ae.org", "whois.centralnic.com", {}],
          [".ar.com", "whois.centralnic.com", {}],
        ])
      end
    end

    it "convert option keys to Symbol" do
      expect(File).to receive(:read).with("tld.json").and_return(<<-JSON)
{
  ".com": {
    "host": "whois.crsnic.net",
    "adapter": "verisign"
  }
}
      JSON
      with_definitions do
        described_class.load_json("tld.json")
        expect(described_class.definitions(:tld)).to eq([
          [".com", "whois.crsnic.net", adapter: "verisign"],
        ])
      end
    end
  end

  describe ".definitions" do
    it "returns the definitions hash when type argument is nil" do
      with_definitions do
        definition = described_class.definitions
        expect(definition).to be_a(Hash)
        expect(definition.keys).to match([:tld, :ipv4, :ipv6, :asn16, :asn32])
      end

      with_definitions do
        definition = described_class.definitions(nil)
        expect(definition).to be_a(Hash)
        expect(definition.keys).to match([:tld, :ipv4, :ipv6, :asn16, :asn32])
      end
    end

    it "returns the definitions array for given type when type argument is not nil and given type exists" do
      with_definitions do
        Whois::Server.define(:foo, ".foo", "whois.foo")
        definition = described_class.definitions(:foo)
        expect(definition).to be_a(Array)
        expect(definition).to eq([[".foo", "whois.foo", {}]])
      end
    end

    it "returns nil when type argument is not nil and given type doesn't exist" do
      with_definitions do
        definition = described_class.definitions(:foo)
        expect(definition).to be_nil
      end
    end
  end

  describe ".define" do
    it "adds a new definition with given arguments" do
      with_definitions do
        Whois::Server.define(:foo, ".foo", "whois.foo")
        expect(described_class.definitions(:foo)).to eq([[".foo", "whois.foo", {}]])
      end
    end

    it "accepts a hash of options" do
      with_definitions do
        Whois::Server.define(:foo, ".foo", "whois.foo", foo: "bar")
        expect(described_class.definitions(:foo)).to eq([[".foo", "whois.foo", { :foo => "bar" }]])
      end
    end

    it "accepts any kind of definition type" do
      with_definitions do
        Whois::Server.define(:ipv4, ".foo", "whois.foo", foo: "bar")
        expect(described_class.definitions(:ipv4)).to eq([[".foo", "whois.foo", { :foo => "bar" }]])
      end
    end
  end

  describe ".factory" do
    it "returns an adapter initialized with given arguments" do
      server = Whois::Server.factory(:tld, ".test", "whois.test")
      expect(server.type).to eq(:tld)
      expect(server.allocation).to eq(".test")
      expect(server.host).to eq("whois.test")
      expect(server.options).to eq(Hash.new)
    end

    it "returns a standard adapter by default" do
      server = Whois::Server.factory(:tld, ".test", "whois.test")
      expect(server).to be_a(Whois::Server::Adapters::Standard)
    end

    it "accepts an :adapter option as Class and returns an instance of given adapter" do
      a = Class.new do
        attr_reader :args
        def initialize(*args)
          @args = args
        end
      end
      server = Whois::Server.factory(:tld, ".test", "whois.test", :adapter => a)
      expect(server).to be_a(a)
      expect(server.args).to eq([:tld, ".test", "whois.test", {}])
    end

    it "accepts an :adapter option as Symbol or String, load Class and returns an instance of given adapter" do
      server = Whois::Server.factory(:tld, ".test", "whois.test", :adapter => :none)
      expect(server).to be_a(Whois::Server::Adapters::None)
      server = Whois::Server.factory(:tld, ".test", "whois.test", :adapter => "none")
      expect(server).to be_a(Whois::Server::Adapters::None)
    end

    it "deletes the adapter option" do
      server = Whois::Server.factory(:tld, ".test", "whois.test", :adapter => Whois::Server::Adapters::None, :foo => "bar")
      expect(server.options).to eq({ :foo => "bar" })
    end
  end

  describe ".guess" do
    it "recognizes tld" do
      server = Whois::Server.guess(".com")
      expect(server).to be_a(Whois::Server::Adapters::Base)
      expect(server.type).to eq(:tld)
    end

    it "recognizes domain" do
      server = Whois::Server.guess("example.com")
      expect(server).to be_a(Whois::Server::Adapters::Base)
      expect(server.type).to eq(:tld)
    end

    it "recognizes ipv4" do
      server = Whois::Server.guess("127.0.0.1")
      expect(server).to be_a(Whois::Server::Adapters::Base)
      expect(server.type).to eq(:ipv4)
    end

    it "recognizes ipv6" do
      server = Whois::Server.guess("2001:0db8:85a3:0000:0000:8a2e:0370:7334")
      expect(server).to be_a(Whois::Server::Adapters::Base)
      expect(server.type).to eq(:ipv6)
    end

    it "recognizes ipv6 when zero groups" do
      server = Whois::Server.guess("2002::1")
      expect(server).to be_a(Whois::Server::Adapters::Base)
      expect(server.type).to eq(:ipv6)
    end

    it "recognizes asn16" do
      server = Whois::Server.guess("AS23456")
      expect(server).to be_a(Whois::Server::Adapters::Base)
      expect(server.type).to eq(:asn16)
    end

    it "recognizes asn32" do
      server = Whois::Server.guess("AS131072")
      expect(server).to be_a(Whois::Server::Adapters::Base)
      expect(server.type).to eq(:asn32)
    end

    it "recognizes email" do
      expect {
        Whois::Server.guess("email@example.org")
      }.to raise_error(Whois::ServerNotSupported, /email/)
    end

    it "raises when unrecognized value" do
      expect {
        Whois::Server.guess("invalid")
      }.to raise_error(Whois::ServerNotFound)
    end


    context "when the input is a tld" do
      it "returns a IANA adapter" do
        expect(Whois::Server.guess(".com")).to eq(Whois::Server.factory(:tld, ".", "whois.iana.org"))
      end

      it "returns a IANA adapter when the input is an idn" do
        expect(Whois::Server.guess(".xn--fiqs8s")).to eq(Whois::Server.factory(:tld, ".", "whois.iana.org"))
      end
    end

    context "when the input is a domain" do
      it "lookups definitions and returns the adapter" do
        with_definitions do
          Whois::Server.define(:tld, ".test", "whois.test")
          expect(Whois::Server.guess("example.test")).to eq(Whois::Server.factory(:tld, ".test", "whois.test"))
        end
      end

      it "doesn't consider the dot as a regexp pattern", :regression => true do
        with_definitions do
          Whois::Server.define(:tld, ".no.com", "whois.no.com")
          Whois::Server.define(:tld, ".com", "whois.com")
          expect(Whois::Server.guess("antoniocangiano.com")).to eq(Whois::Server.factory(:tld, ".com", "whois.com"))
        end
      end
    end

    context "when the input is a ipv4" do
      it "lookups definitions and returns the adapter" do
        with_definitions do
          Whois::Server.define(:ipv4, "192.168.1.0/10", "whois.test")
          expect(Whois::Server.guess("192.168.1.1")).to eq(Whois::Server.factory(:ipv4, "192.168.1.0/10", "whois.test"))
        end
      end

      it "raises if definition is not found" do
        with_definitions do
          Whois::Server.define(:ipv4, "192.168.1.0/10", "whois.test")
          expect {
            Whois::Server.guess("192.192.0.1")
          }.to raise_error(Whois::AllocationUnknown)
        end
      end
    end

    context "when the input is a ipv6" do
      it "lookups definitions and returns the adapter" do
        with_definitions do
          Whois::Server.define(:ipv6, "2001:0200::/23", "whois.test")
          expect(Whois::Server.guess("2001:0200::1")).to eq(Whois::Server.factory(:ipv6, "2001:0200::/23", "whois.test"))
        end
      end

      it "raises if definition is not found" do
        with_definitions do
          Whois::Server.define(:ipv6, "::1", "whois.test")
          expect {
            Whois::Server.guess("2002:0300::1")
          }.to raise_error(Whois::AllocationUnknown)
        end
      end

      it "recognizes ipv4 compatibility mode" do
        with_definitions do
          Whois::Server.define(:ipv6, "::192.168.1.1", "whois.test")
          expect(Whois::Server.guess("::192.168.1.1")).to eq(Whois::Server.factory(:ipv6, "::192.168.1.1", "whois.test"))
        end
      end

      # https://github.com/weppos/whois/issues/174
      it "rescues IPAddr ArgumentError" do
        with_definitions do
          expect {
            Whois::Server.guess("f53")
          }.to raise_error(Whois::AllocationUnknown)
        end
      end
    end

    context "when the input is an asn16" do
      it "lookups definitions and returns the adapter" do
        with_definitions do
          Whois::Server.define(:asn16, "0 65535", "whois.test")
          expect(Whois::Server.guess("AS65535")).to eq(Whois::Server.factory(:asn16, "0 65535", "whois.test"))
        end
      end

      it "raises if definition is not found" do
        with_definitions do
          Whois::Server.define(:asn16, "0 60000", "whois.test")
          expect {
            Whois::Server.guess("AS65535")
          }.to raise_error(Whois::AllocationUnknown)
        end
      end
    end

    context "when the input is an asn32" do
      it "lookups definitions and returns the adapter" do
        with_definitions do
          Whois::Server.define(:asn32, "65536 394239", "whois.test")
          expect(Whois::Server.guess("AS65536")).to eq(Whois::Server.factory(:asn32, "65536 394239", "whois.test"))
        end
      end

      it "raises if definition is not found" do
        with_definitions do
          Whois::Server.define(:asn32, "65536 131071", "whois.test")
          expect {
            Whois::Server.guess("AS200000")
          }.to raise_error(Whois::AllocationUnknown)
        end
      end
    end
  end

end
