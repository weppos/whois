# encoding: utf-8

# This file is autogenerated. Do not edit it manually.
# If you want change the content of this file, edit
#
#   /spec/fixtures/responses/whois.dns.lu/property_nameservers_with_ip.expected
#
# and regenerate the tests with the following rake task
#
#   $ rake spec:generate
#

require 'spec_helper'
require 'whois/record/parser/whois.dns.lu.rb'

describe Whois::Record::Parser::WhoisDnsLu, "property_nameservers_with_ip.expected" do

  subject do
    file = fixture("responses", "whois.dns.lu/property_nameservers_with_ip.txt")
    part = Whois::Record::Part.new(body: File.read(file))
    described_class.new(part)
  end

  describe "#nameservers" do
    it do
      expect(subject.nameservers).to be_a(Array)
      expect(subject.nameservers.size).to eq(3)
      expect(subject.nameservers[0]).to be_a(Whois::Record::Nameserver)
      expect(subject.nameservers[0].name).to eq("ns1.arbed.lu")
      expect(subject.nameservers[0].ipv4).to eq("194.154.218.10")
      expect(subject.nameservers[1]).to be_a(Whois::Record::Nameserver)
      expect(subject.nameservers[1].name).to eq("ns1.pt.lu")
      expect(subject.nameservers[1].ipv4).to eq(nil)
      expect(subject.nameservers[2]).to be_a(Whois::Record::Nameserver)
      expect(subject.nameservers[2].name).to eq("ns2.arbed.lu")
      expect(subject.nameservers[2].ipv4).to eq("194.154.218.12")
    end
  end
end
