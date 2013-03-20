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

        record = Whois.query("example.it")

        record.should be_a(Whois::Record)
        record.should be_available
        record.should_not be_registered

        record.parser.should be_a(Whois::Record::Parser)
        record.parser.parsers.first.should be_a(Whois::Record::Parser::WhoisNicIt)
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
        record.parts.size.should == 1
        record.parts.first.body.should == response
        record.parts.first.host.should == "whois.example.com"
      end
    end
  end

end
