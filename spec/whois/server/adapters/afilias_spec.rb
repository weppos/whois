require 'spec_helper'

describe Whois::Server::Adapters::Afilias do

  let(:definition) { [:tld, ".test", "whois.afilias-grs.info", {}] }
  let(:server) { described_class.new(*definition) }


  describe "#lookup" do
    context "without referral" do
      it "returns the WHOIS record" do
        response = "No match for example.test."
        expected = response
        expect(server.query_handler).to receive(:call).with("example.test", "whois.afilias-grs.info", 43).and_return(response)

        record = server.lookup("example.test")
        expect(record.to_s).to eq(expected)
        expect(record.parts.size).to eq(1)
        expect(record.parts).to eq([Whois::Record::Part.new(body: response, host: "whois.afilias-grs.info")])
      end
    end

    context "with referral" do
      it "follows all referrals" do
        referral = File.read(fixture("referrals/afilias.bz.txt"))
        response = "Match for example.test."
        expected = referral + "\n" + response
        expect(server.query_handler).to receive(:call).with("example.test", "whois.afilias-grs.info", 43).and_return(referral)
        expect(server.query_handler).to receive(:call).with("example.test", "whois.belizenic.bz", 43).and_return(response)

        record = server.lookup("example.test")
        expect(record.to_s).to eq(expected)
        expect(record.parts.size).to eq(2)
        expect(record.parts).to eq([Whois::Record::Part.new(body: referral, host: "whois.afilias-grs.info"), Whois::Record::Part.new(body: response, host: "whois.belizenic.bz")])
      end

      it "ignores referral if options[:referral] is false" do
        referral = File.read(fixture("referrals/afilias.bz.txt"))
        server.options[:referral] = false
        expect(server.query_handler).to receive(:call).with("example.test", "whois.afilias-grs.info", 43).and_return(referral)
        expect(server.query_handler).to receive(:call).with("example.test", "whois.belizenic.bz", 43).never

        record = server.lookup("example.test")
        expect(record.parts.size).to eq(1)
      end
    end
  end

end
