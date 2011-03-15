require "spec_helper"

describe Whois::Server::Adapters::Verisign do

  before(:each) do
    @definition = [:tld, ".test", "whois.test", {}]
    @server = klass.new(*@definition)
  end


  describe "#query" do
    context "without referral" do
      it "returns the WHOIS record" do
        response = "No match for DOMAIN.TEST."
        expected = response
        @server.expects(:ask_the_socket).with("=domain.test", "whois.test", 43, Whois::Server::Adapters::Base::DEFAULT_BIND_HOST, nil).returns(response)

        record = @server.query("domain.test")
        record.to_s.should  == expected
        record.parts.should have(1).part
        record.parts.should == [Whois::Record::Part.new(response, "whois.test")]
      end
    end

    context "with referral" do
      it "follows all referrals" do
        referral = File.read(fixture("referrals/crsnic.com.txt"))
        response = "Match for DOMAIN.TEST."
        expected = referral + "\n" + response
        @server.expects(:ask_the_socket).with("=domain.test", "whois.test", 43, Whois::Server::Adapters::Base::DEFAULT_BIND_HOST, nil).returns(referral)
        @server.expects(:ask_the_socket).with("domain.test", "whois.markmonitor.com", 43, Whois::Server::Adapters::Base::DEFAULT_BIND_HOST, nil).returns(response)

        record = @server.query("domain.test")
        record.to_s.should  == expected
        record.parts.should have(2).parts
        record.parts.should == [Whois::Record::Part.new(referral, "whois.test"), Whois::Record::Part.new(response, "whois.markmonitor.com")]
      end

      it "ignore referral when is not defined" do
        referral = File.read(fixture("referrals/crsnic.com_referral_not_defined.txt"))
        @server.expects(:ask_the_socket).with("=domain.test", "whois.test", 43, Whois::Server::Adapters::Base::DEFAULT_BIND_HOST, nil).returns(referral)
        @server.expects(:ask_the_socket).never

        record = @server.query("domain.test")
        record.parts.should have(1).part
      end

      it "extracts the closest referral when multiple referrals" do
        referral = File.read(fixture("referrals/crsnic.com_referral_multiple.txt"))
        @server.expects(:ask_the_socket).with("=domain.test", "whois.test", 43, Whois::Server::Adapters::Base::DEFAULT_BIND_HOST, nil).returns(referral)
        @server.expects(:ask_the_socket).with("domain.test", "whois.markmonitor.com", 43, Whois::Server::Adapters::Base::DEFAULT_BIND_HOST, nil).returns("")

        record = @server.query("domain.test")
        record.parts.should have(2).parts
      end
    end
  end

end
