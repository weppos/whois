require 'spec_helper'
require 'whois/answer/parser/whois.denic.de'

describe Whois::Answer::Parser::WhoisDenicDe, "Schema 2.0" do

  before(:each) do
    @host   = "whois.denic.de"
    @schema = "schema-2.0"
  end


  describe "#throttled?" do
    context "valid response" do
      it "returns false" do
        klass.new(load_part('status_registered.txt')).throttled?.should be_false
      end
    end
    context "throttle response" do
      it "returns true" do
        klass.new(load_part('response_throttled.txt')).throttled?.should be_true
      end
    end
  end

end
