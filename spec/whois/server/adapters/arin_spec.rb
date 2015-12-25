require 'spec_helper'

describe Whois::Server::Adapters::Arin do

  let(:definition) { [:ipv4, "0.0.0.0/1", "whois.arin.net"] }
  let(:server) { described_class.new(*definition) }

  describe "#lookup" do
    context "without referral" do
      it "returns the WHOIS record" do
        response = "Whois Response"
        expected = response
        expect(server.query_handler).to receive(:call).with("n + 0.0.0.0", "whois.arin.net", 43).and_return(response)
        record = server.lookup("0.0.0.0")
        expect(record.to_s).to eq(expected)
        expect(record.parts.size).to eq(1)
        expect(record.parts).to eq([Whois::Record::Part.new(body: response, host: "whois.arin.net")])
      end
    end

    context "with referral" do
      it "follows whois:// referrals" do
        referral = File.read(fixture("referrals/arin_referral_whois.txt"))
        response = "Whois Response"
        expected = referral + "\n" + response
        expect(server.query_handler).to receive(:call).with("n + 0.0.0.0", "whois.arin.net", 43).and_return(referral)
        expect(server.query_handler).to receive(:call).with("0.0.0.0", "whois.ripe.net", 43).and_return(response)

        record = server.lookup("0.0.0.0")
        expect(record.to_s).to eq(expected)
        expect(record.parts.size).to eq(2)
        expect(record.parts).to eq([Whois::Record::Part.new(body: referral, host: "whois.arin.net"),
                                    Whois::Record::Part.new(body: response, host: "whois.ripe.net")])
      end

      it "follows rwhois:// referrals" do
        referral = File.read(fixture("referrals/arin_referral_rwhois.txt"))
        response = "Whois Response"
        expected = referral + "\n" + response
        expect(server.query_handler).to receive(:call).with("n + 0.0.0.0", "whois.arin.net", 43).and_return(referral)
        expect(server.query_handler).to receive(:call).with("0.0.0.0", "rwhois.servernap.net", 4321).and_return(response)

        record = server.lookup("0.0.0.0")
        expect(record.to_s).to eq(expected)
        expect(record.parts.size).to eq(2)
        expect(record.parts).to eq([Whois::Record::Part.new(body: referral, host: "whois.arin.net"),
                                    Whois::Record::Part.new(body: response, host: "rwhois.servernap.net")])
      end

      it "ignores referral if options[:referral] is false" do
        referral = File.read(fixture("referrals/arin_referral_whois.txt"))
        server.options[:referral] = false
        expect(server.query_handler).to receive(:call).with("n + 0.0.0.0", "whois.arin.net", 43).and_return(referral)
        expect(server.query_handler).to receive(:call).with("0.0.0.0", "whois.ripe.net", 43).never

        record = server.lookup("0.0.0.0")
        expect(record.parts.size).to eq(1)
      end

      it "ignores referral (gracefully) if missing" do
        referral = File.read(fixture("referrals/arin_referral_missing.txt"))
        expect(server.query_handler).to receive(:call).with("n + 0.0.0.0", "whois.arin.net", 43).and_return(referral)
        expect(server.query_handler).to receive(:call).never

        record = server.lookup("0.0.0.0")
        expect(record.parts.size).to eq(1)
      end

      it "folows referrals without ports" do
        referral = File.read(fixture("referrals/arin_referral_apnic.txt"))
        response = "Whois Response"
        expect(server.query_handler).to receive(:call).with("n + 0.0.0.0", "whois.arin.net", 43).and_return(referral)
        expect(server.query_handler).to receive(:call).with("0.0.0.0", "whois.apnic.net", 43).and_return(response)

        record = server.lookup("0.0.0.0")
        expect(record.parts.size).to eq(2)
        expect(record.parts).to eq([Whois::Record::Part.new(body: referral, host: "whois.arin.net"),
                                    Whois::Record::Part.new(body: response, host: "whois.apnic.net")])
      end
    end

  end

end
