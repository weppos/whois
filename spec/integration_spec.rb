require "spec_helper"

describe Whois do

  describe "Basic WHOIS querying and parsing" do
    it "works" do
      with_definitions do
        Whois::Server.define(:tld, ".it", "whois.nic.it")
        Whois::Server::Adapters::Standard.any_instance.expects(:query_the_socket).with("example.it", "whois.nic.it").returns(<<-EOS)
  Domain:             example.it
  Status:             AVAILABLE
        EOS

        answer = Whois.query("example.it")

        answer.should be_a(Whois::Answer)
        answer.should be_available
        answer.should_not be_registered

        answer.parser.should be_a(Whois::Answer::Parser)
        answer.parser.parsers.first.should be_a(Whois::Answer::Parser::WhoisNicIt)
      end
    end
  end

end
