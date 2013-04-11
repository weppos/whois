require 'spec_helper'

describe Whois::Server::Adapters::Arpa do

  let(:definition) { [:tld, ".in-addr.arpa", nil, {}] }

  describe "#lookup" do
    it "returns the WHOIS record" do
      response = "Whois Response"
      server = described_class.new(*definition)
      server.query_handler.expects(:call).with("n + 229.128.in-addr.arpa", "whois.arin.net", 43).returns(response)

      record = server.lookup("229.128.in-addr.arpa")
      record.to_s.should  eq(response)
      record.parts.should eq([Whois::Record::Part.new(body: response, host: "whois.arin.net")])
    end
  end

end
