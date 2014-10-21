# encoding: utf-8

# This file is autogenerated. Do not edit it manually.
# If you want change the content of this file, edit
#
#   /spec/fixtures/responses/whois.nic.uk/status_registered.expected
#
# and regenerate the tests with the following rake task
#
#   $ rake spec:generate
#

require 'spec_helper'
require 'whois/record/parser/whois.nic.uk.rb'

describe Whois::Record::Parser::WhoisNicUk, "status_registered.expected" do

  subject do
    file = fixture("responses", "whois.nic.uk/status_registered.txt")
    part = Whois::Record::Part.new(body: File.read(file))
    described_class.new(part)
  end

  describe "#status" do
    it do
      expect(subject.status).to eq(:registered)
    end
  end
  describe "#available?" do
    it do
      expect(subject.available?).to be_falsey
    end
  end
  describe "#registered?" do
    it do
      expect(subject.registered?).to be_truthy
    end
  end
  describe "#created_on" do
    it do
      expect(subject.created_on).to be_a(Time)
      expect(subject.created_on).to eq(Time.parse("1999-02-14"))
    end
  end
  describe "#updated_on" do
    it do
      expect(subject.updated_on).to be_a(Time)
      expect(subject.updated_on).to eq(Time.parse("2014-01-13"))
    end
  end
  describe "#expires_on" do
    it do
      expect(subject.expires_on).to be_a(Time)
      expect(subject.expires_on).to eq(Time.parse("2015-02-14"))
    end
  end
  describe "#registrar" do
    it do
      expect(subject.registrar).to be_a(Whois::Record::Registrar)
      expect(subject.registrar.id).to eq("MARKMONITOR")
      expect(subject.registrar.name).to eq("Markmonitor")
      expect(subject.registrar.organization).to eq("Markmonitor Inc.")
      expect(subject.registrar.url).to eq("http://www.markmonitor.com")
    end
  end
  describe "#registrant_contacts" do
    it do
      expect(subject.registrant_contacts).to be_a(Array)
      expect(subject.registrant_contacts.size).to eq(1)
      expect(subject.registrant_contacts[0]).to be_a(Whois::Record::Contact)
      expect(subject.registrant_contacts[0].type).to eq(Whois::Record::Contact::TYPE_REGISTRANT)
      expect(subject.registrant_contacts[0].id).to eq(nil)
      expect(subject.registrant_contacts[0].name).to eq("Google Inc.")
      expect(subject.registrant_contacts[0].organization).to eq(nil)
      expect(subject.registrant_contacts[0].address).to eq("1600 Amphitheatre Parkway")
      expect(subject.registrant_contacts[0].city).to eq("Mountain View")
      expect(subject.registrant_contacts[0].zip).to eq("94043")
      expect(subject.registrant_contacts[0].state).to eq("CA")
      expect(subject.registrant_contacts[0].country).to eq("United States")
    end
  end
  describe "#nameservers" do
    it do
      expect(subject.nameservers).to be_a(Array)
      expect(subject.nameservers.size).to eq(4)
      expect(subject.nameservers[0]).to be_a(Whois::Record::Nameserver)
      expect(subject.nameservers[0].name).to eq("ns1.google.com")
      expect(subject.nameservers[1]).to be_a(Whois::Record::Nameserver)
      expect(subject.nameservers[1].name).to eq("ns2.google.com")
      expect(subject.nameservers[2]).to be_a(Whois::Record::Nameserver)
      expect(subject.nameservers[2].name).to eq("ns3.google.com")
      expect(subject.nameservers[3]).to be_a(Whois::Record::Nameserver)
      expect(subject.nameservers[3].name).to eq("ns4.google.com")
    end
  end
  describe "#response_throttled?" do
    it do
      expect(subject.response_throttled?).to be_falsey
    end
  end
  describe "#valid?" do
    it do
      expect(subject.valid?).to be_truthy
    end
  end
  describe "#invalid?" do
    it do
      expect(subject.invalid?).to be_falsey
    end
  end
end
