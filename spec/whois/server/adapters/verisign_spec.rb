require 'spec_helper'

describe Whois::Server::Adapters::Verisign do

  let(:definition) { [:tld, ".test", "whois.test", {}] }
  let(:server) { described_class.new(*definition) }


  describe "#lookup" do
    context "without referral" do
      it "returns the WHOIS record" do
        response = "No match for example.test."
        expected = response
        expect(server.query_handler).to receive(:call).with("=example.test", "whois.test", 43).and_return(response)

        record = server.lookup("example.test")
        expect(record.to_s).to eq(expected)
        expect(record.parts.size).to eq(1)
        expect(record.parts).to eq([Whois::Record::Part.new(body: response, host: "whois.test")])
      end
    end

    context "with referral" do
      it "follows all referrals" do
        referral = File.read(fixture("referrals/crsnic.com.txt"))
        response = "Match for example.test."
        expected = referral + "\n" + response
        expect(server.query_handler).to receive(:call).with("=example.test", "whois.test", 43).and_return(referral)
        expect(server.query_handler).to receive(:call).with("example.test", "whois.markmonitor.com", 43).and_return(response)

        record = server.lookup("example.test")
        expect(record.to_s).to eq(expected)
        expect(record.parts.size).to eq(2)
        expect(record.parts).to eq([Whois::Record::Part.new(body: referral, host: "whois.test"), Whois::Record::Part.new(body: response, host: "whois.markmonitor.com")])
      end

      it "extracts the closest referral if multiple referrals" do
        referral = File.read(fixture("referrals/crsnic.com_referral_multiple.txt"))
        expect(server.query_handler).to receive(:call).with("=example.test", "whois.test", 43).and_return(referral)
        expect(server.query_handler).to receive(:call).with("example.test", "whois.markmonitor.com", 43).and_return("")

        record = server.lookup("example.test")
        expect(record.parts.size).to eq(2)
      end

      it "ignores referral if is not defined" do
        referral = File.read(fixture("referrals/crsnic.com_referral_not_defined.txt"))
        expect(server.query_handler).to receive(:call).with("=example.test", "whois.test", 43).and_return(referral)
        expect(server.query_handler).to receive(:call).never

        record = server.lookup("example.test")
        expect(record.parts.size).to eq(1)
      end

      it "ignores referral if options[:referral] is false" do
        referral = File.read(fixture("referrals/crsnic.com.txt"))
        server.options[:referral] = false
        expect(server.query_handler).to receive(:call).with("=example.test", "whois.test", 43).and_return(referral)
        expect(server.query_handler).to receive(:call).never

        record = server.lookup("example.test")
        expect(record.parts.size).to eq(1)
      end

      # (see #103)
      # This is the case of vrsn-20100925-dnssecmonitor86.net
      it "ignores referral (gracefully) if missing" do
        referral = File.read(fixture("referrals/crsnic.com_referral_missing.txt"))
        expect(server.query_handler).to receive(:call).with("=example.test", "whois.test", 43).and_return(referral)
        expect(server.query_handler).to receive(:call).never

        record = server.lookup("example.test")
        expect(record.parts.size).to eq(1)
      end
    end
  end

end
