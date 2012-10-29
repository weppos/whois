require 'spec_helper'

describe Whois::Server::Adapters::Afilias do

  let(:definition) { [:tld, ".test", "whois.afilias-grs.info", {}] }
  let(:server) { described_class.new(*definition) }


  describe "#lookup" do
    context "without referral" do
      it "returns the WHOIS record" do
        response = "No match for DOMAIN.TEST."
        expected = response
        server.query_handler.expects(:call).with("domain.test", "whois.afilias-grs.info", 43).returns(response)

        record = server.lookup("domain.test")
        record.to_s.should  == expected
        record.parts.should have(1).part
        record.parts.should == [Whois::Record::Part.new(:body => response, :host => "whois.afilias-grs.info")]
      end
    end

    context "with referral" do
      it "follows all referrals" do
        referral = File.read(fixture("referrals/afilias.bz.txt"))
        response = "Match for DOMAIN.TEST."
        expected = referral + "\n" + response
        server.query_handler.expects(:call).with("domain.test", "whois.afilias-grs.info", 43).returns(referral)
        server.query_handler.expects(:call).with("domain.test", "whois.belizenic.bz", 43).returns(response)

        record = server.lookup("domain.test")
        record.to_s.should  == expected
        record.parts.should have(2).parts
        record.parts.should == [Whois::Record::Part.new(:body => referral, :host => "whois.afilias-grs.info"), Whois::Record::Part.new(:body => response, :host => "whois.belizenic.bz")]
      end
    end
  end

end
