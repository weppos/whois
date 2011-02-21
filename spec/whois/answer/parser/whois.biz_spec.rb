require 'spec_helper'
require 'whois/answer/parser/whois.biz'

describe Whois::Answer::Parser::WhoisBiz do

  before(:each) do
    @host   = "whois.biz"
  end


  describe "#domain" do
    context "status registered" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('status_registered.txt'))
        expected  = "google.biz"
        parser.domain.should == expected
        parser.should cache_property(:domain)
      end
    end
    context "status available" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('status_available.txt'))
        expected  = "u34jedzcq.biz"
        parser.domain.should == expected
        parser.should cache_property(:domain)
      end
    end
  end

  describe "#domain_id" do
    context "status registered" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('status_registered.txt'))
        expected  = "D2835288-BIZ"
        parser.domain_id.should == expected
        parser.should cache_property(:domain_id)
      end
    end
    context "status available" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('status_available.txt'))
        expected  = nil
        parser.domain_id.should == expected
        parser.should cache_property(:domain_id)
      end
    end
  end


  describe "#referral_whois" do
    context "status registered" do
      it "is not supported" do
        klass.new(load_part('status_registered.txt')).should_not support_property(:referral_whois)
      end
    end
    context "status available" do
      it "is not supported" do
        klass.new(load_part('status_available.txt')).should_not support_property(:referral_whois)
      end
    end
  end

  describe "#referral_url" do
    context "status registered" do
      it "is not supported" do
        klass.new(load_part('status_registered.txt')).should_not support_property(:referral_url)
      end
    end
    context "status available" do
      it "is not supported" do
        klass.new(load_part('status_available.txt')).should_not support_property(:referral_url)
      end
    end
  end


  describe "#status" do
    context "status registered" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('status_registered.txt'))
        expected  = %w( clientDeleteProhibited clientTransferProhibited clientUpdateProhibited )
        parser.status.should == expected
        parser.should cache_property(:available?)
      end
    end
    context "status available" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('status_available.txt'))
        expected  = nil
        parser.status.should == expected
        parser.should cache_property(:available?)
      end
    end
  end

  describe "#available?" do
    context "status registered" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('status_registered.txt'))
        expected  = false
        parser.available?.should == expected
        parser.should cache_property(:available?)
      end
    end
    context "status available" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('status_available.txt'))
        expected  = true
        parser.available?.should == expected
        parser.should cache_property(:available?)
      end
    end
  end

  describe "#registered?" do
    context "status registered" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('status_registered.txt'))
        expected  = true
        parser.registered?.should == expected
        parser.should cache_property(:registered?)
      end
    end
    context "status available" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('status_available.txt'))
        expected  = false
        parser.registered?.should == expected
        parser.should cache_property(:registered?)
      end
    end
  end


  describe "#created_on" do
    context "status registered" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('status_registered.txt'))
        expected  = Time.parse("2002-03-27 00:01:00 GMT")
        parser.created_on.should == expected
        parser.should cache_property(:created_on)
      end
    end
    context "status available" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('status_available.txt'))
        expected  = nil
        parser.created_on.should == expected
        parser.should cache_property(:created_on)
      end
    end
  end

  describe "#updated_on" do
    context "status registered" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('status_registered.txt'))
        expected  = Time.parse("2009-03-01 12:01:04 GMT")
        parser.updated_on.should == expected
        parser.should cache_property(:updated_on)
      end
    end
    context "status available" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('status_available.txt'))
        expected  = nil
        parser.updated_on.should == expected
        parser.should cache_property(:updated_on)
      end
    end
  end

  describe "#expires_on" do
    context "status registered" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('status_registered.txt'))
        expected  = Time.parse("2010-03-26 23:59:59 GMT")
        parser.expires_on.should == expected
        parser.should cache_property(:expires_on)
      end
    end
    context "status available" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('status_available.txt'))
        expected  = nil
        parser.expires_on.should == expected
        parser.should cache_property(:expires_on)
      end
    end
  end


  describe "#registrar" do
    context "when any" do
      it "returns a Registrar" do
        parser    = klass.new(load_part('status_registered.txt'))
        parser.registrar.should be_a(Whois::Answer::Registrar)
      end
      it "caches the value" do
        parser    = klass.new(load_part('status_registered.txt'))
        parser.should cache_property(:registrar)
      end
      it "parses the attributes" do
        parser    = klass.new(load_part('status_registered.txt'))
        object    = parser.registrar
        object.id.should      == "292"
        object.name.should    == "MARKMONITOR, INC."
      end
    end
    context "when none" do
      it "returns an empty array" do
        parser    = klass.new(load_part('status_available.txt'))
        parser.registrar.should be_nil
      end
      it "caches the value" do
        parser    = klass.new(load_part('status_available.txt'))
        parser.should cache_property(:registrar)
      end
    end
  end

  describe "#registrant_contact" do
    context "when any" do
      it "returns a Contact" do
        parser    = klass.new(load_part('status_registered.txt'))
        parser.registrant_contact.should be_a(Whois::Answer::Contact)
      end
      it "caches the value" do
        parser    = klass.new(load_part('status_registered.txt'))
        parser.should cache_property(:registrant_contact)
      end
    end
    context "when none" do
      it "returns an empty array" do
        parser    = klass.new(load_part('status_available.txt'))
        parser.registrant_contact.should be_nil
      end
      it "caches the value" do
        parser    = klass.new(load_part('status_available.txt'))
        parser.should cache_property(:registrant_contact)
      end
    end
  end

  describe "#admin_contact" do
    context "when any" do
      it "returns a Contact" do
        parser    = klass.new(load_part('status_registered.txt'))
        parser.admin_contact.should be_a(Whois::Answer::Contact)
      end
      it "caches the value" do
        parser    = klass.new(load_part('status_registered.txt'))
        parser.should cache_property(:admin_contact)
      end
    end
    context "when none" do
      it "returns an empty array" do
        parser    = klass.new(load_part('status_available.txt'))
        parser.admin_contact.should be_nil
      end
      it "caches the value" do
        parser    = klass.new(load_part('status_available.txt'))
        parser.should cache_property(:admin_contact)
      end
    end
  end

  describe "#technical_contact" do
    context "when any" do
      it "returns a Contact" do
        parser    = klass.new(load_part('status_registered.txt'))
        parser.technical_contact.should be_a(Whois::Answer::Contact)
      end
      it "caches the value" do
        parser    = klass.new(load_part('status_registered.txt'))
        parser.should cache_property(:technical_contact)
      end
    end
    context "when none" do
      it "returns an empty array" do
        parser    = klass.new(load_part('status_available.txt'))
        parser.technical_contact.should be_nil
      end
      it "caches the value" do
        parser    = klass.new(load_part('status_available.txt'))
        parser.should cache_property(:technical_contact)
      end
    end
  end


  describe "#nameservers" do
    nameservers__when_none
    nameservers__when_any

    context "when only name" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('status_registered.txt'))
        names     = %w( ns1.google.com ns2.google.com ns3.google.com ns4.google.com )
        expected  = names.map { |name| nameserver(name) }
        parser.nameservers.should == expected
      end
    end
  end

end
