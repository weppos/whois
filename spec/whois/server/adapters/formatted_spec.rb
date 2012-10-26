require "spec_helper"

describe Whois::Server::Adapters::Formatted do

  let(:definition) { [:tld, ".de", "whois.denic.de", { :format => "-T dn,ace -C US-ASCII %s" }] }


  describe "#query" do
    it "returns the WHOIS record" do
      response = "Whois Response"
      expected = response
      server = klass.new(*definition)
      server.query_handler.expects(:call).with("-T dn,ace -C US-ASCII domain.de", "whois.denic.de", 43).returns(response)

      record = server.query("domain.de")
      record.to_s.should  == expected
      record.parts.should == [Whois::Record::Part.new(:body => response, :host => "whois.denic.de")]
    end

    context "without format option" do
      it "raises an error" do
        lambda do
          server = klass.new(*[:tld, ".de", "whois.denic.de", {}])
          server.query_handler.expects(:call).never
          server.query("domain.de")
        end.should raise_error(Whois::ServerError)
      end
    end

    context "with port option" do
      it "sends the request to given port" do
        response = "Whois Response"
        server = klass.new(:tld, ".de", "whois.denic.de", { :format => "-T dn,ace -C US-ASCII %s", :port => 20 })
        server.query_handler.expects(:call).with("-T dn,ace -C US-ASCII domain.de", "whois.denic.de", 20).returns(response)

        server.query("domain.de")
      end
    end

    context "with bind option" do
      it "binds the request to given host and port" do
        response = "Whois Response"
        server = klass.new(:tld, ".de", "whois.denic.de", { :format => "-T dn,ace -C US-ASCII %s" })
        server.configure(:bind_host => "192.168.1.1", :bind_port => 3000)
        server.query_handler.expects(:call).with("-T dn,ace -C US-ASCII domain.de", "whois.denic.de", 43, "192.168.1.1", 3000).returns(response)

        server.query("domain.de")
      end
    end
  end

end
