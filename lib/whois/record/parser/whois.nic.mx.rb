#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/whois.nic.mx.rb'


module Whois
  class Record
    class Parser

      #
      # = whois.nic.mx parser
      #
      # Parser for the whois.nic.mx server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicMx < Base
        include Scanners::Scannable

        # We call WhoisNicMx scanner which hashes the given server string into 
        # key, value hashes.
        self.scanner = Scanners::WhoisNicMx

        property_supported :disclaimer do
           node("field:disclaimer")
        end

        property_supported :domain do
          if content_for_scanner =~ /Domain Name:\s+(.*)\n/
            $1
          end
        end

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /Object_Not_Found/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Created On:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Last Updated On:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Expiration Date:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :nameservers do
          if content_for_scanner =~ /Name Servers:\n((.+\n)+)\n/
            $1.scan(/DNS:\s+(.+)\n/).flatten.map do |line|
              name, ipv4 = line.strip.split(/\s+/)
              Record::Nameserver.new(:name => name, :ipv4 => ipv4)
            end
          end
        end

        # .mx domains only output name and url
        property_supported :registrar do

          Record::Registrar.new(
              :name => content_for_scanner[/Registrar:\s+(.+)\n/, 1],
              :url => content_for_scanner[/URL:\s+(.+)\n/, 1]
          )
        end

        property_supported :registrant_contacts do
          build_contact("Registrant", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact("Administrative Contact", Whois::Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact("Technical Contact", Whois::Record::Contact::TYPE_TECHNICAL)
        end

        # This method retrieves the hashed information from the scanner and parses it into contact.
        # whois.nic.mx only gives out contact information with name, city, state, and country.
        def build_contact(element, type)
          node(element) do |hash|
            Record::Contact.new(
              :type         => type,
              :id           => nil,
              :name         => hash["Name"],
              :organization => nil,
              :address      => nil,
              :city         => hash["City"],
              :zip          => nil,
              :state        => hash["State"],
              :country      => hash["Country"],
              :phone        => nil,
              :fax          => nil,
              :email        => nil
            )
          end
        end
      end
    end
  end
end
