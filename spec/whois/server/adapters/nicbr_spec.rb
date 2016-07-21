require 'spec_helper'

describe Whois::Server::Adapters::Nicbr do

  let(:definition) { [:tld, ".test", "whois.gtlds.nic.br", {}] }
  let(:server) { described_class.new(*definition) }


  describe "#lookup" do
    context "without referral" do
      it "returns the WHOIS record" do
        response = "No match for example.test."
        expected = response
        expect(server.query_handler).to receive(:call).with("example.test", "whois.gtlds.nic.br", 43).and_return(response)

        record = server.lookup("example.test")
        expect(record.to_s).to eq(expected)
        expect(record.parts.size).to eq(1)
        expect(record.parts).to eq([Whois::Record::Part.new(body: response, host: "whois.gtlds.nic.br")])
      end
    end

  end

end
