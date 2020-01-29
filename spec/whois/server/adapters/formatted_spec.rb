# frozen_string_literal: true

require 'spec_helper'

describe Whois::Server::Adapters::Formatted do
  let(:definition) { [:tld, ".de", "whois.denic.de", { format: "-T dn,ace -C US-ASCII %s" }] }


  describe "#lookup" do
    it "returns the WHOIS record" do
      response = "Whois Response"
      expected = response
      server = described_class.new(*definition)
      expect(server.query_handler).to receive(:call).with("-T dn,ace -C US-ASCII domain.de", "whois.denic.de", 43).and_return(response)

      record = server.lookup("domain.de")
      expect(record.to_s).to eq(expected)
      expect(record.parts).to eq([Whois::Record::Part.new(body: response, host: "whois.denic.de")])
    end

    context "without format option" do
      it "raises an error" do
        server = described_class.new(:tld, ".de", "whois.denic.de", {})
        expect(server.query_handler).to receive(:call).never

        expect {
          server.lookup("domain.de")
        }.to raise_error(Whois::ServerError)
      end
    end

    context "with port option" do
      it "sends the request to given port" do
        response = "Whois Response"
        server = described_class.new(:tld, ".de", "whois.denic.de", { format: "-T dn,ace -C US-ASCII %s", port: 20 })
        expect(server.query_handler).to receive(:call).with("-T dn,ace -C US-ASCII domain.de", "whois.denic.de", 20).and_return(response)

        server.lookup("domain.de")
      end
    end

    context "with bind option" do
      it "binds the request to given host and port" do
        response = "Whois Response"
        server = described_class.new(:tld, ".de", "whois.denic.de", { format: "-T dn,ace -C US-ASCII %s" })
        server.configure(bind_host: "192.168.1.1", bind_port: 3000)
        expect(server.query_handler).to receive(:call).with("-T dn,ace -C US-ASCII domain.de", "whois.denic.de", 43, "192.168.1.1", 3000).and_return(response)

        server.lookup("domain.de")
      end
    end
  end
end
