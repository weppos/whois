# This file is autogenerated. Do not edit it manually.
# If you want change the content of this file, edit
#
#   /spec/whois/answer/parser/responses/whois.registry.in/property_status_missing_spec.rb
#
# and regenerate the tests with the following rake task
#
#   $ rake genspec:parsers
#

require 'spec_helper'
require 'whois/answer/parser/whois.registry.in'

describe Whois::Answer::Parser::WhoisRegistryIn, "property_status_missing.expected" do

  before(:each) do
    file = fixture("responses", "whois.registry.in/property_status_missing.txt")
    part = Whois::Answer::Part.new(:body => File.read(file))
    @parser = klass.new(part)
  end

  context "#status" do
    it do
      @parser.status.should == nil
    end
  end
end