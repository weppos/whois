require 'spec_helper'
require 'whois/answer/parser/whois.nic.io'

describe Whois::Answer::Parser::WhoisNicIo do

  before(:each) do
    @host   = "whois.nic.io"
  end

  describe "#disclaimer" do
    context "status registered" do
      it "is not supported" do
        klass.new(load_part('status_registered.txt')).should_not support_property(:disclaimer)
      end
    end
    context "status available" do
      it "is not supported" do
        klass.new(load_part('status_available.txt')).should_not support_property(:disclaimer)
      end
    end
  end


  describe "#domain_id" do
    context "status registered" do
      it "is not supported" do
        klass.new(load_part('status_registered.txt')).should_not support_property(:domain_id)
      end
    end
    context "status available" do
      it "is not supported" do
        klass.new(load_part('status_available.txt')).should_not support_property(:domain_id)
      end
    end
  end

  describe "#domain" do
    context "status registered" do
      it "is supported" do
        parser    = klass.new(load_part('status_registered.txt'))
        expected  = "drop.io"
        assert_equal_and_cached expected, parser, :domain
      end
    end
    context "status available" do
      it "is supported" do
        parser    = klass.new(load_part('status_available.txt'))
        expected  = "u34jedzcq.io"
        assert_equal_and_cached expected, parser, :domain
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
      it "is supported" do
        parser    = klass.new(load_part('status_registered.txt'))
        expected  = :registered
        assert_equal_and_cached expected, parser, :status
      end
    end
    context "status available" do
      it "is supported" do
        parser    = klass.new(load_part('status_available.txt'))
        expected  = :available
        assert_equal_and_cached expected, parser, :status
      end
    end
  end

  describe "#available?" do
    context "status registered" do
      it "is supported" do
        parser    = klass.new(load_part('status_registered.txt'))
        expected  = false
        assert_equal_and_cached expected, parser, :available?
      end
    end
    context "status available" do
      it "is supported" do
        parser    = klass.new(load_part('status_available.txt'))
        expected  = true
        assert_equal_and_cached expected, parser, :available?
      end
    end
  end

  describe "#registered?" do
    context "status registered" do
      it "is supported" do
        parser    = klass.new(load_part('status_registered.txt'))
        expected  = true
        assert_equal_and_cached expected, parser, :registered?
      end
    end
    context "status available" do
      it "is supported" do
        parser    = klass.new(load_part('status_available.txt'))
        expected  = false
        assert_equal_and_cached expected, parser, :registered?
      end
    end
  end


  describe "#created_on" do
    context "status registered" do
      it "is not supported" do
        klass.new(load_part('status_registered.txt')).should_not support_property(:created_on)
      end
    end
    context "status available" do
      it "is not supported" do
        klass.new(load_part('status_available.txt')).should_not support_property(:created_on)
      end
    end
  end

  describe "#updated_on" do
    context "status registered" do
      it "is not supported" do
        klass.new(load_part('status_registered.txt')).should_not support_property(:updated_on)
      end
    end
    context "status available" do
      it "is not supported" do
        klass.new(load_part('status_available.txt')).should_not support_property(:updated_on)
      end
    end
  end

  describe "#expires_on" do
    context "status registered" do
      it "is not supported" do
        klass.new(load_part('status_registered.txt')).should_not support_property(:expires_on)
      end
    end
    context "status available" do
      it "is not supported" do
        klass.new(load_part('status_available.txt')).should_not support_property(:expires_on)
      end
    end
  end


  describe "#registrar" do
    context "status registered" do
      it "is not supported" do
        klass.new(load_part('status_registered.txt')).should_not support_property(:registrar)
      end
    end
    context "status available" do
      it "is not supported" do
        klass.new(load_part('status_available.txt')).should_not support_property(:registrar)
      end
    end
  end

  describe "#registrant_contact" do
    context "status registered" do
      it "is not supported" do
        klass.new(load_part('status_registered.txt')).should_not support_property(:registrant_contact)
      end
    end
    context "status available" do
      it "is not supported" do
        klass.new(load_part('status_available.txt')).should_not support_property(:registrant_contact)
      end
    end
  end

  describe "#admin_contact" do
    context "status registered" do
      it "is not supported" do
        klass.new(load_part('status_registered.txt')).should_not support_property(:admin_contact)
      end
    end
    context "status available" do
      it "is not supported" do
        klass.new(load_part('status_available.txt')).should_not support_property(:admin_contact)
      end
    end
  end

  describe "#technical_contact" do
    context "status registered" do
      it "is not supported" do
        klass.new(load_part('status_registered.txt')).should_not support_property(:technical_contact)
      end
    end
    context "status available" do
      it "is not supported" do
        klass.new(load_part('status_available.txt')).should_not support_property(:technical_contact)
      end
    end
  end


  describe "#nameservers" do
    context "status registered" do
      it "is not supported" do
        klass.new(load_part('status_registered.txt')).should_not support_property(:nameservers)
      end
    end
    context "status available" do
      it "is not supported" do
        klass.new(load_part('status_available.txt')).should_not support_property(:nameservers)
      end
    end
  end

end
