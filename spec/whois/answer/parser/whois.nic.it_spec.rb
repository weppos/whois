require 'spec_helper'
require 'whois/answer/parser/whois.nic.it'

describe Whois::Answer::Parser::WhoisNicIt do

  before(:each) do
    @host   = "whois.nic.it"
  end


  # TODO: test property patterns instead of each different type
  describe "#status" do
    context "status registered" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('property_status_active.txt'))
        expected  = :registered
        parser.should support_property_and_cache(:status, expected)
      end
    end
    context "status ok" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('property_status_ok.txt'))
        expected  = :registered
        parser.should support_property_and_cache(:status, expected)
      end
    end
    context "status ok autorenew" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('property_status_ok.txt'))
        expected  = :registered
        parser.should support_property_and_cache(:status, expected)
      end
    end
    context "status client" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('property_status_ok.txt'))
        expected  = :registered
        parser.should support_property_and_cache(:status, expected)
      end
    end
    context "status pendingDelete" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('property_status_pendingdelete.txt'))
        expected  = :registered
        parser.should support_property_and_cache(:status, expected)
      end
    end
    context "status available" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('property_status_available.txt'))
        expected  = :available
        parser.should support_property_and_cache(:status, expected)
      end
    end
  end

  describe "#available?" do
    context "status registered" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('property_status_active.txt'))
        expected  = false
        parser.should support_property_and_cache(:available?, expected)
      end
    end
    context "status ok" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('property_status_ok.txt'))
        expected  = false
        parser.should support_property_and_cache(:available?, expected)
      end
    end
    context "status ok autorenew" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('property_status_ok.txt'))
        expected  = false
        parser.should support_property_and_cache(:available?, expected)
      end
    end
    context "status client" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('property_status_ok.txt'))
        expected  = false
        parser.should support_property_and_cache(:available?, expected)
      end
    end
    context "status pendingDelete" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('property_status_pendingdelete.txt'))
        expected  = false
        parser.should support_property_and_cache(:available?, expected)
      end
    end
    context "status available" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('property_status_available.txt'))
        expected  = true
        parser.should support_property_and_cache(:available?, expected)
      end
    end
  end

  describe "#registered?" do
    context "status registered" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('property_status_active.txt'))
        expected  = true
        parser.should support_property_and_cache(:registered?, expected)
      end
    end
    context "status ok" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('property_status_ok.txt'))
        expected  = true
        parser.should support_property_and_cache(:registered?, expected)
      end
    end
    context "status ok autorenew" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('property_status_ok.txt'))
        expected  = true
        parser.should support_property_and_cache(:registered?, expected)
      end
    end
    context "status client" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('property_status_ok.txt'))
        expected  = true
        parser.should support_property_and_cache(:registered?, expected)
      end
    end
    context "status pendingDelete" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('property_status_pendingdelete.txt'))
        expected  = true
        parser.should support_property_and_cache(:registered?, expected)
      end
    end
    context "status available" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('property_status_available.txt'))
        expected  = false
        parser.should support_property_and_cache(:registered?, expected)
      end
    end
  end

end
