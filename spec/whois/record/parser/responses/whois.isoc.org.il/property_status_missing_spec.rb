# encoding: utf-8

# This file is autogenerated. Do not edit it manually.
# If you want change the content of this file, edit
#
#   /spec/fixtures/responses/whois.isoc.org.il/property_status_missing.expected
#
# and regenerate the tests with the following rake task
#
#   $ rake spec:generate
#

require 'spec_helper'
require 'whois/record/parser/whois.isoc.org.il.rb'

describe Whois::Record::Parser::WhoisIsocOrgIl, "property_status_missing.expected" do

  subject do
    file = fixture("responses", "whois.isoc.org.il/property_status_missing.txt")
    part = Whois::Record::Part.new(body: File.read(file))
    described_class.new(part)
  end

  describe "#status" do
    it do
      expect(subject.status).to eq(:available)
    end
  end
  describe "#available?" do
    it do
      expect(subject.available?).to be_truthy
    end
  end
  describe "#registered?" do
    it do
      expect(subject.registered?).to be_falsey
    end
  end
end
