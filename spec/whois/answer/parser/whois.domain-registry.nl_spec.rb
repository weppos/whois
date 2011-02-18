require 'spec_helper'
require 'whois/answer/parser/whois.domain-registry.nl'

describe Whois::Answer::Parser::WhoisDomainRegistryNl do

  before(:each) do
    @host   = "whois.domain-registry.nl"
  end


  describe "#throttle?" do
    context "valid response" do
      it "returns false" do
        klass.new(load_part('status_registered.txt')).throttle?.should be_false
      end
    end
    context "throttled response" do
      it "returns true" do
        klass.new(load_part('response_throttled.txt')).throttle?.should be_true
      end
    end
    context "daily throttled response" do
      it "returns true" do
        klass.new(load_part('response_throttled_daily.txt')).throttle?.should be_true
      end
    end
  end

end
