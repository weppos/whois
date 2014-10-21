# encoding: utf-8

# This file is autogenerated. Do not edit it manually.
# If you want change the content of this file, edit
#
#   /spec/fixtures/responses/whois.educause.edu/status_available.expected
#
# and regenerate the tests with the following rake task
#
#   $ rake spec:generate
#

require 'spec_helper'
require 'whois/record/parser/whois.educause.edu.rb'

describe Whois::Record::Parser::WhoisEducauseEdu, "status_available.expected" do

  subject do
    file = fixture("responses", "whois.educause.edu/status_available.txt")
    part = Whois::Record::Part.new(body: File.read(file))
    described_class.new(part)
  end

  describe "#disclaimer" do
    it do
      expect(subject.disclaimer).to eq("\nThis Registry database contains ONLY .EDU domains. \nThe data in the EDUCAUSE Whois database is provided \nby EDUCAUSE for information purposes in order to \nassist in the process of obtaining information about \nor related to .edu domain registration records. \n\nThe EDUCAUSE Whois database is authoritative for the \n.EDU domain.         \n\nA Web interface for the .EDU EDUCAUSE Whois Server is \navailable at: http://whois.educause.net \n\nBy submitting a Whois query, you agree that this information \nwill not be used to allow, enable, or otherwise support \nthe transmission of unsolicited commercial advertising or \nsolicitations via e-mail.  The use of electronic processes to \nharvest information from this server is generally prohibited \nexcept as reasonably necessary to register or modify .edu \ndomain names.\n\nYou may use \"%\" as a wildcard in your search. For further \ninformation regarding the use of this WHOIS server, please \ntype: help \n")
    end
  end
  describe "#domain" do
    it do
      expect(subject.domain).to eq(nil)
    end
  end
  describe "#domain_id" do
    it do
      expect { subject.domain_id }.to raise_error(Whois::AttributeNotSupported)
    end
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
  describe "#created_on" do
    it do
      expect(subject.created_on).to eq(nil)
    end
  end
  describe "#updated_on" do
    it do
      expect(subject.updated_on).to eq(nil)
    end
  end
  describe "#expires_on" do
    it do
      expect(subject.expires_on).to eq(nil)
    end
  end
  describe "#registrar" do
    it do
      expect { subject.registrar }.to raise_error(Whois::AttributeNotSupported)
    end
  end
  describe "#registrant_contacts" do
    it do
      expect(subject.registrant_contacts).to be_a(Array)
      expect(subject.registrant_contacts).to eq([])
    end
  end
  describe "#admin_contacts" do
    it do
      expect(subject.admin_contacts).to be_a(Array)
      expect(subject.admin_contacts).to eq([])
    end
  end
  describe "#technical_contacts" do
    it do
      expect(subject.technical_contacts).to be_a(Array)
      expect(subject.technical_contacts).to eq([])
    end
  end
  describe "#nameservers" do
    it do
      expect(subject.nameservers).to be_a(Array)
      expect(subject.nameservers).to eq([])
    end
  end
end
