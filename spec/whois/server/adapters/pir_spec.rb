require "spec_helper"

describe Whois::Server::Adapters::Pir do

  before(:each) do
    @definition = [:tld, ".test", "whois.publicinterestregistry.net", {}]
    @server = klass.new(*@definition)
  end


  describe "#query" do
    context "without referral" do
      it "returns the WHOIS record" do
        response = "No match for DOMAIN.TEST."
        expected = response
        @server.expects(:ask_the_socket).with("FULL domain.test", "whois.publicinterestregistry.net", 43).returns(response)

        record = @server.query("domain.test")
        record.to_s.should  == expected
        record.parts.should have(1).part
        record.parts.should == [Whois::Record::Part.new(response, "whois.publicinterestregistry.net")]
      end
    end

    context "with referral" do
      it "follows all referrals" do
        referral = File.read(fixture("referrals/pir.org.txt"))
        response = "Match for DOMAIN.TEST."
        expected = referral + "\n" + response
        @server.expects(:ask_the_socket).with("FULL domain.test", "whois.publicinterestregistry.net", 43).returns(referral)
        @server.expects(:ask_the_socket).with("domain.test", "whois.iana.org", 43).returns(response)

        record = @server.query("domain.test")
        record.to_s.should  == expected
        record.parts.should have(2).parts
        record.parts.should == [Whois::Record::Part.new(referral, "whois.publicinterestregistry.net"), Whois::Record::Part.new(response, "whois.iana.org")]
      end
    end
  end

end
