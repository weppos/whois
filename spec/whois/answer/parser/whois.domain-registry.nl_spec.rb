require 'spec_helper'
require 'whois/answer/parser/whois.domain-registry.nl'

describe Whois::Answer::Parser::WhoisDomainRegistryNl do

  before(:each) do
    @host   = "whois.domain-registry.nl"
  end


  describe "#throttled?" do
    context "valid response" do
      it "returns false" do
        klass.new(load_part('status_registered.txt')).throttled?.should be_false
      end
    end
    context "throttled response" do
      it "returns true" do
        klass.new(load_part('response_throttled.txt')).throttled?.should be_true
      end
    end
    context "daily throttled response" do
      it "returns true" do
        klass.new(load_part('response_throttled_daily.txt')).throttled?.should be_true
      end
    end
  end

end
