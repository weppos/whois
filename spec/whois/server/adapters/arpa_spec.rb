require 'spec_helper'
require 'whois/server/adapters/arin'

describe Whois::Server::Adapters::Arpa do

  let(:definition) { [:tld, ".in-addr.arpa", nil, {}] }

  describe "#lookup" do
    it "returns the WHOIS record" do
      response = "Whois Response"
      server = described_class.new(*definition)
      expect(Whois::Server::Adapters::Arin.query_handler).to receive(:call).with("n + 229.128.in-addr.arpa", "whois.arin.net", 43).and_return(response)

      record = server.lookup("229.128.in-addr.arpa")
      expect(record.to_s).to eq(response)
      expect(record.parts).to eq([Whois::Record::Part.new(body: response, host: "whois.arin.net")])
    end
  end

end
