# frozen_string_literal: true

require "spec_helper"

describe Whois::Server::Adapters::Standard do
  let(:definition) { [:tld, ".test", "whois.test", {}] }


  describe "#lookup" do
    it "returns the WHOIS record" do
      response = "Whois Response"
      expected = response
      server = described_class.new(*definition)
      expect(server.query_handler).to receive(:call).with("domain.test", "whois.test", 43).and_return(response)

      record = server.lookup("domain.test")
      expect(record.to_s).to eq(expected)
      expect(record.parts).to eq([Whois::Record::Part.new(body: response, host: "whois.test")])
    end

    context "with port option" do
      it "sends the request to given port" do
        response = "Whois Response"
        server = described_class.new(:tld, ".test", "whois.test", { port: 20 })
        expect(server.query_handler).to receive(:call).with("domain.test", "whois.test", 20).and_return(response)

        server.lookup("domain.test")
      end
    end

    context "with bind option" do
      it "binds the request to given host and port" do
        response = "Whois Response"
        server = described_class.new(:tld, ".test", "whois.test", { port: 20 })
        server.configure(bind_host: "192.168.1.100", bind_port: 3000)
        expect(server.query_handler).to receive(:call).with("domain.test", "whois.test", 20, "192.168.1.100", 3000).and_return(response)

        server.lookup("domain.test")
      end
    end
  end
end
