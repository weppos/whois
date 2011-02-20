require 'spec_helper'
require 'whois/answer/parser/whois.nic.fr'

describe Whois::Answer::Parser::WhoisNicFr, ".FR" do

  before(:each) do
    @host   = "whois.nic.fr"
    @suffix = "fr"
  end


  describe "#nameservers" do
    nameservers__when_none
    nameservers__when_any

    context "when only name" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('property_nameservers.txt'))
        names     = %w( ns1.google.com ns2.google.com ns3.google.com ns4.google.com )
        expected  = names.map { |name| nameserver(name) }
        parser.nameservers.should == expected
      end
    end
    context "when mixed ipv4 and some ipv6" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('property_nameservers_with_ipv4_and_some_ipv6.txt'))
        names     = ["ns1.nic.fr", "ns2.nic.fr", "ns3.nic.fr", "ns1.ext.nic.fr", "ns4.ext.nic.fr", "ns5.ext.nic.fr"]
        ipv4s     = ["192.134.4.1", "192.93.0.4", "192.134.0.49", "193.51.208.13", "193.0.9.4", "206.167.244.5"]
        ipv6s     = ["2001:660:3003:2::4:1", "2001:660:3005:1::1:2", "2001:660:3006:1::1:1", nil, "2001:67c:e0::4", nil]
        expected  = names.zip(ipv4s, ipv6s).map { |name, ipv4, ipv6| nameserver(name, ipv4, ipv6) }
        parser.nameservers.should == expected
      end
    end
  end

end

describe Whois::Answer::Parser::WhoisNicFr, ".PM" do

  before(:each) do
    @host   = "whois.nic.fr"
    @suffix = "pm"
  end


  describe "#nameservers" do
    nameservers__when_none
    nameservers__when_any

    context "when mixed ipv4 and ipv6" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('property_nameservers_with_ipv4_and_ipv6.txt'))
        names     = %w( ns1.nic.fr           ns2.nic.fr           ns3.nic.fr           )
        ipv4s     = %w( 192.93.0.1           192.93.0.4           192.134.0.49         )
        ipv6s     = %w( 2001:660:3005:1::1:1 2001:660:3005:1::1:2 2001:660:3006:1::1:1 )
        expected  = names.zip(ipv4s, ipv6s).map { |name, ipv4, ipv6| nameserver(name, ipv4, ipv6) }
        parser.nameservers.should == expected
      end
    end
  end

end

describe Whois::Answer::Parser::WhoisNicFr, ".RE" do

  before(:each) do
    @host   = "whois.nic.fr"
    @suffix = "re"
  end


  describe "#nameservers" do
    nameservers__when_none
    nameservers__when_any

    context "when mixed ipv4 and ipv6" do
      it "returns and cache the value" do
        parser    = klass.new(load_part('property_nameservers_with_ipv4_and_ipv6.txt'))
        names     = %w( ns1.nic.fr           ns2.nic.fr           ns3.nic.fr           )
        ipv4s     = %w( 192.93.0.1           192.93.0.4           192.134.0.49         )
        ipv6s     = %w( 2001:660:3005:1::1:1 2001:660:3005:1::1:2 2001:660:3006:1::1:1 )
        expected  = names.zip(ipv4s, ipv6s).map { |name, ipv4, ipv6| nameserver(name, ipv4, ipv6) }
        parser.nameservers.should == expected
      end
    end
  end

end
