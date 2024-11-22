# frozen_string_literal: true

require "spec_helper"
require "whois/server/adapters/arin"

describe Whois::Server::Adapters::Arpa do
  let(:definition) { [:tld, ".in-addr.arpa", nil, {}] }

  describe "#lookup" do
    it "returns the WHOIS record" do
      server = described_class.new(*definition)
      expect(Whois::Server::Adapters::Arin.query_handler).to receive(:call)
        .with("n + 229.128.in-addr.arpa", "whois.arin.net", 43)
        .and_return(response = "Whois Response")

      record = server.lookup("229.128.in-addr.arpa")
      expect(record.to_s).to eq(response)
      expect(record.parts).to eq([Whois::Record::Part.new(body: response, host: "whois.arin.net")])
    end

    it "discards newlines" do
      server = described_class.new(*definition)

      expect do
        server.lookup("229.128.in-addr.arpa\nextra")
      end.to raise_error(Whois::ServerError, "Invalid .in-addr.arpa address")
    end
  end
end
