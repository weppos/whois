require "spec_helper"

describe Whois do

  let(:response)    { "Domain:             example.it\nStatus:             AVAILABLE\n" }

  describe "Basic WHOIS querying and parsing" do
    it "works" do
      with_definitions do
        Whois::Server.define(:tld, ".it", "whois.nic.it")
        Whois::Server::Adapters::Standard.any_instance \
            .expects(:ask_the_socket) \
            .with("example.it", "whois.nic.it", 43) \
            .returns(response)

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
        Whois::Server::Adapters::Standard.any_instance \
            .expects(:ask_the_socket) \
            .with("example.it", "whois.nic.it", 43, "192.168.1.1", 3000) \
            .returns(response)

        client = Whois::Client.new(:bind_host => "192.168.1.1", :bind_port => 3000)
        client.query("example.it")
      end
    end
  end

  describe "Passing :bind_port options" do
    it "binds the WHOIS query to given port and defaults host" do
      with_definitions do
        Whois::Server.define(:tld, ".it", "whois.nic.it")
        Whois::Server::Adapters::Standard.any_instance \
            .expects(:ask_the_socket) \
            .with("example.it", "whois.nic.it", 43, Whois::Server::Adapters::Base::DEFAULT_BIND_HOST, 3000) \
            .returns(response)

        client = Whois::Client.new(:bind_port => 3000)
        client.query("example.it")
      end
    end
  end

end
