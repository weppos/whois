require 'spec_helper'

describe Whois::Server::Adapters::Standard do

  let(:definition) { [:tld, ".test", "whois.test", {}] }


  describe "#lookup" do
    it "returns the WHOIS record" do
      response = "Whois Response"
      expected = response
      server = described_class.new(*definition)
      server.query_handler.expects(:call).with("domain.test", "whois.test", 43).returns(response)

      record = server.lookup("domain.test")
      record.to_s.should  == expected
      record.parts.should == [Whois::Record::Part.new(:body => response, :host => "whois.test")]
    end

    context "with port option" do
      it "sends the request to given port" do
        response = "Whois Response"
        server = described_class.new(:tld, ".test", "whois.test", { :port => 20 })
        server.query_handler.expects(:call).with("domain.test", "whois.test", 20).returns(response)

        server.lookup("domain.test")
      end
    end

    context "with bind option" do
      it "binds the request to given host and port" do
        response = "Whois Response"
        server = described_class.new(:tld, ".test", "whois.test", { :port => 20 })
        server.configure(:bind_host => "192.168.1.100", :bind_port => 3000)
        server.query_handler.expects(:call).with("domain.test", "whois.test", 20, "192.168.1.100", 3000).returns(response)

        server.lookup("domain.test")
      end
    end
  end

end
