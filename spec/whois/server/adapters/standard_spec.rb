require "spec_helper"

describe Whois::Server::Adapters::Standard do

  let(:definition) { [:tld, ".test", "whois.test", {}] }


  describe "#query" do
    it "returns the WHOIS record" do
      response = "Whois Response"
      expected = response
      server = klass.new(*definition)
      server.query_handler.expects(:call).with("domain.test", "whois.test", 43).returns(response)

      record = server.query("domain.test")
      record.to_s.should  == expected
      record.parts.should == [Whois::Record::Part.new(:body => response, :host => "whois.test")]
    end

    context "with port option" do
      it "sends the request to given port" do
        response = "Whois Response"
        server = klass.new(:tld, ".test", "whois.test", { :port => 20 })
        server.query_handler.expects(:call).with("domain.test", "whois.test", 20).returns(response)

        server.query("domain.test")
      end
    end

    context "with bind option" do
      it "binds the request to given host and port" do
        response = "Whois Response"
        server = klass.new(:tld, ".test", "whois.test", { :port => 20 })
        server.configure(:bind_host => "192.168.1.100", :bind_port => 3000)
        server.query_handler.expects(:call).with("domain.test", "whois.test", 20, "192.168.1.100", 3000).returns(response)

        server.query("domain.test")
      end
    end
  end

end
