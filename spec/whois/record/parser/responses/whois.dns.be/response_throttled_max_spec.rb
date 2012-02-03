# encoding: utf-8

# This file is autogenerated. Do not edit it manually.
# If you want change the content of this file, edit
#
#   /spec/fixtures/responses/whois.dns.be/response_throttled_max.expected
#
# and regenerate the tests with the following rake task
#
#   $ rake spec:generate
#

require 'spec_helper'
require 'whois/record/parser/whois.dns.be.rb'

describe Whois::Record::Parser::WhoisDnsBe, "response_throttled_max.expected" do

  before(:each) do
    file = fixture("responses", "whois.dns.be/response_throttled_max.txt")
    part = Whois::Record::Part.new(:body => File.read(file))
    @parser = klass.new(part)
  end

  describe "#response_throttled?" do
    it do
      @parser.response_throttled?.should == true
    end
  end
end
