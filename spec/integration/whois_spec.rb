require 'spec_helper'

describe Whois do

  let(:response)    { "Domain:             example.it\nStatus:             AVAILABLE\n" }

  describe "Basic WHOIS querying and parsing" do
    it "works" do
      with_definitions do
        Whois::Server.define(:tld, ".it", "whois.nic.it")
        Whois::Server::Adapters::Base.
            query_handler.expects(:call).
            with("example.it", "whois.nic.it", 43).
            returns(response)

        record = Whois.lookup("example.it")

        expect(record).to be_a(Whois::Record)
        expect(record.available?).to be_true
        expect(record.registered?).to be_false

        expect(record.parser).to be_a(Whois::Record::Parser)
        expect(record.parser.parsers.first).to be_a(Whois::Record::Parser::WhoisNicIt)
      end
    end
  end

  describe "Passing :bind_host and :bind_port options" do
    it "binds the WHOIS query to given host and port" do
      with_definitions do
        Whois::Server.define(:tld, ".it", "whois.nic.it")
        Whois::Server::Adapters::Base.
            query_handler.expects(:call).
            with("example.it", "whois.nic.it", 43, "192.168.1.1", 3000).
            returns(response)

        client = Whois::Client.new(:bind_host => "192.168.1.1", :bind_port => 3000)
        client.lookup("example.it")
      end
    end
  end

  describe "Passing :bind_port options" do
    it "binds the WHOIS query to given port and defaults host" do
      with_definitions do
        Whois::Server.define(:tld, ".it", "whois.nic.it")
        Whois::Server::Adapters::Base.
            query_handler.expects(:call).
            with("example.it", "whois.nic.it", 43, Whois::Server::Adapters::Base::DEFAULT_BIND_HOST, 3000).
            returns(response)

        client = Whois::Client.new(:bind_port => 3000)
        client.lookup("example.it")
      end
    end
  end

  describe "Passing :host options" do
    it "forces the WHOIS query to given host" do
      with_definitions do
        Whois::Server.define(:tld, ".it", "whois.nic.it")
        Whois::Server::Adapters::Base.
            query_handler.expects(:call).
            with("example.it", "whois.example.com", 43).
            returns(response)

        client = Whois::Client.new(:host => "whois.example.com")
        record = client.lookup("example.it")

        expect(record.parts.size).to eq(1)
        expect(record.parts.first.body).to eq(response)
        expect(record.parts.first.host).to eq("whois.example.com")
      end
    end
  end

end
