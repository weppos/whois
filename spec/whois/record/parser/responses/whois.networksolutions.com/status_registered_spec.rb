# encoding: utf-8

# This file is autogenerated. Do not edit it manually.
# If you want change the content of this file, edit
#
#   /spec/fixtures/responses/whois.networksolutions.com/status_registered.expected
#
# and regenerate the tests with the following rake task
#
#   $ rake spec:generate
#

require 'spec_helper'
require 'whois/record/parser/whois.networksolutions.com.rb'

describe Whois::Record::Parser::WhoisNetworksolutionsCom, "status_registered.expected" do

  before(:each) do
    file = fixture("responses", "whois.networksolutions.com/status_registered.txt")
    part = Whois::Record::Part.new(:body => File.read(file))
    @parser = klass.new(part)
  end

  describe "#status" do
    it do
      lambda { @parser.status }.should raise_error(Whois::PropertyNotSupported)
    end
  end
  describe "#available?" do
    it do
      @parser.available?.should == false
    end
  end
  describe "#registered?" do
    it do
      @parser.registered?.should == true
    end
  end
  describe "#response_throttled?" do
    it do
      @parser.response_throttled?.should == false
    end
  end
  describe "#created_on" do
    it do
      @parser.created_on.should be_a(Time)
      @parser.created_on.should == Time.parse("1997-06-10")
    end
  end
  describe "#updated_on" do
    it do
      lambda { @parser.updated_on }.should raise_error(Whois::PropertyNotSupported)
    end
  end
  describe "#expires_on" do
    it do
      @parser.expires_on.should be_a(Time)
      @parser.expires_on.should == Time.parse("2014-06-09")
    end
  end
  describe "#registrar" do
    it do
      @parser.registrar.should be_a(Whois::Record::Registrar)
      @parser.registrar.name.should         == "Network Solutions"
      @parser.registrar.organization.should == "Network Solutions, LLC"
      @parser.registrar.url.should          == "http://www.networksolutions.com/"
    end
  end
  describe "#registrant_contacts" do
    it do
      @parser.registrant_contacts.should be_a(Array)
      @parser.registrant_contacts.should have(1).items
      @parser.registrant_contacts[0].should be_a(Whois::Record::Contact)
      @parser.registrant_contacts[0].type.should         == Whois::Record::Contact::TYPE_REGISTRANT
      @parser.registrant_contacts[0].name.should         == nil
      @parser.registrant_contacts[0].organization.should == "XIF Communications"
      @parser.registrant_contacts[0].address.should      == "1200 New Hampshire Avenue NW\nSuite 410"
      @parser.registrant_contacts[0].city.should         == "Washington"
      @parser.registrant_contacts[0].zip.should          == "20036"
      @parser.registrant_contacts[0].state.should        == "DC"
      @parser.registrant_contacts[0].country_code.should == "US"
      @parser.registrant_contacts[0].phone.should        == nil
      @parser.registrant_contacts[0].fax.should          == nil
      @parser.registrant_contacts[0].email.should        == nil
    end
  end
  describe "#admin_contacts" do
    it do
      @parser.admin_contacts.should be_a(Array)
      @parser.admin_contacts.should have(1).items
      @parser.admin_contacts[0].should be_a(Whois::Record::Contact)
      @parser.admin_contacts[0].type.should         == Whois::Record::Contact::TYPE_ADMIN
      @parser.admin_contacts[0].name.should         == "Communications, XIF ContactMiddleName"
      @parser.admin_contacts[0].organization.should == "XIF Communications"
      @parser.admin_contacts[0].address.should      == "1200 New Hampshire Avenue NW\nSuite 410"
      @parser.admin_contacts[0].city.should         == "Washington"
      @parser.admin_contacts[0].zip.should          == "20036"
      @parser.admin_contacts[0].state.should        == "DC"
      @parser.admin_contacts[0].country_code.should == "US"
      @parser.admin_contacts[0].phone.should        == "202-463-7200"
      @parser.admin_contacts[0].fax.should          == "202-318-4003"
      @parser.admin_contacts[0].email.should        == "noc@xif.com"
    end
  end
  describe "#technical_contacts" do
    it do
      @parser.technical_contacts.should be_a(Array)
      @parser.technical_contacts.should have(1).items
      @parser.technical_contacts[0].should be_a(Whois::Record::Contact)
      @parser.technical_contacts[0].type.should         == Whois::Record::Contact::TYPE_TECHNICAL
      @parser.technical_contacts[0].name.should         == "Communications, XIF ContactMiddleName"
      @parser.technical_contacts[0].organization.should == "XIF Communications"
      @parser.technical_contacts[0].address.should      == "1200 New Hampshire Avenue NW\nSuite 410"
      @parser.technical_contacts[0].city.should         == "Washington"
      @parser.technical_contacts[0].zip.should          == "20036"
      @parser.technical_contacts[0].state.should        == "DC"
      @parser.technical_contacts[0].country_code.should == "US"
      @parser.technical_contacts[0].phone.should        == "202-463-7200"
      @parser.technical_contacts[0].fax.should          == "202-318-4003"
      @parser.technical_contacts[0].email.should        == "noc@xif.com"
    end
  end
  describe "#nameservers" do
    it do
      @parser.nameservers.should be_a(Array)
      @parser.nameservers.should have(3).items
      @parser.nameservers[0].should be_a(Whois::Record::Nameserver)
      @parser.nameservers[0].name.should == "ns01.xif.com"
      @parser.nameservers[0].ipv4.should == "63.240.200.70"
      @parser.nameservers[1].should be_a(Whois::Record::Nameserver)
      @parser.nameservers[1].name.should == "ns-east.cerf.net"
      @parser.nameservers[1].ipv4.should == "207.252.96.3"
      @parser.nameservers[2].should be_a(Whois::Record::Nameserver)
      @parser.nameservers[2].name.should == "ns-west.cerf.net"
      @parser.nameservers[2].ipv4.should == "192.153.156.3"
    end
  end
end
