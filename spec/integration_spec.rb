require "spec_helper"

describe Whois do

  describe "Basic WHOIS querying and parsing" do
    it "works" do
      with_definitions do
        Whois::Server.define(:tld, ".it", "whois.nic.it")
        Whois::Server::Adapters::Standard.any_instance.expects(:ask_the_socket).with("example.it", "whois.nic.it", 43, Whois::Server::Adapters::Base::DEFAULT_BIND_HOST, nil).returns(<<-EOS)
  Domain:             example.it
  Status:             AVAILABLE
        EOS

        record = Whois.query("example.it")

        record.should be_a(Whois::Record)
        record.should be_available
        record.should_not be_registered

        record.parser.should be_a(Whois::Record::Parser)
        record.parser.parsers.first.should be_a(Whois::Record::Parser::WhoisNicIt)
      end
    end
  end

  describe "Binding a WHOIS query to a different local host and port" do
    it "works" do
      with_definitions do
        Whois::Server.define(:tld, ".it", "whois.nic.it")
        Whois::Server::Adapters::Standard.any_instance.expects(:ask_the_socket).with("example.it", "whois.nic.it", 43, "127.0.0.1", 3000).returns(<<-EOS)
  Domain:             example.it
  Status:             AVAILABLE
        EOS

        client = Whois::Client.new(:bind_host => "127.0.0.1", :bind_port => 3000)
        record = client.query("example.it")
      end
    end
  end

end
