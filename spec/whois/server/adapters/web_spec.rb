require "spec_helper"

describe Whois::Server::Adapters::Web do

  before(:each) do
    @definition = [:tld, ".test", nil, { :url => "http://whois.test" }]
  end


  describe "#query" do
    it "raises Whois::WebInterfaceError" do
      lambda do
        klass.new(*@definition).query("example.test")
      end.should raise_error(Whois::WebInterfaceError)
    end

    it "customizes the error message with the WHOIS web url" do
      lambda do
        klass.new(*@definition).query("example.test")
      end.should raise_error(Whois::WebInterfaceError, /whois\.test/)
    end
  end

end
