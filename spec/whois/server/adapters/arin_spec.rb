require 'spec_helper'

describe Whois::Server::Adapters::Arin do

  let(:definition) { [:ipv4, "0.0.0.0/1", "whois.arin.net"] }
  let(:server) { described_class.new(*definition) }

  describe "#lookup" do
    context "without referral" do
      it "returns the WHOIS record" do
        response = "Whois Response"
        expected = response
        server.query_handler.expects(:call).with("n + 0.0.0.0", "whois.arin.net", 43).returns(response)
        record = server.lookup("0.0.0.0")
        record.to_s.should  == expected
        record.parts.should have(1).part
        record.parts.should == [Whois::Record::Part.new(:body => response, :host => "whois.arin.net")]
      end
    end

    context "with referral" do
      it "follows whois:// referrals" do
        referral = File.read(fixture("referrals/arin_referral_whois.txt"))
        response = "Whois Response"
        expected = referral + "\n" + response
        server.query_handler.expects(:call).with("n + 0.0.0.0", "whois.arin.net", 43).returns(referral)
        server.query_handler.expects(:call).with("0.0.0.0", "whois.ripe.net", 43).returns(response)

        record = server.lookup("0.0.0.0")
        record.to_s.should  == expected
        record.parts.should have(2).parts
        record.parts.should == [Whois::Record::Part.new(:body => referral, :host => "whois.arin.net"),
                                Whois::Record::Part.new(:body => response, :host => "whois.ripe.net")]
      end

      it "follows rwhois:// referrals" do
        referral = File.read(fixture("referrals/arin_referral_rwhois.txt"))
        response = "Whois Response"
        expected = referral + "\n" + response
        server.query_handler.expects(:call).with("n + 0.0.0.0", "whois.arin.net", 43).returns(referral)
        server.query_handler.expects(:call).with("0.0.0.0", "rwhois.servernap.net", 4321).returns(response)

        record = server.lookup("0.0.0.0")
        record.to_s.should  == expected
        record.parts.should have(2).parts
        record.parts.should == [Whois::Record::Part.new(:body => referral, :host => "whois.arin.net"),
                                Whois::Record::Part.new(:body => response, :host => "rwhois.servernap.net")]
      end

      it "ignores referral if options[:referral] is false" do
        referral = File.read(fixture("referrals/arin_referral_whois.txt"))
        server.options[:referral] = false
        server.query_handler.expects(:call).with("n + 0.0.0.0", "whois.arin.net", 43).returns(referral)
        server.query_handler.expects(:call).with("0.0.0.0", "whois.ripe.net", 43).never
       
        record = server.lookup("0.0.0.0")
        record.parts.should have(1).part
      end

      it "ignores referral (gracefully) if missing" do
        referral = File.read(fixture("referrals/arin_referral_missing.txt"))
        server.query_handler.expects(:call).with("n + 0.0.0.0", "whois.arin.net", 43).returns(referral)
        server.query_handler.expects(:call).never
       
        record = server.lookup("0.0.0.0")
        record.parts.should have(1).part
      end
    end

  end

end
