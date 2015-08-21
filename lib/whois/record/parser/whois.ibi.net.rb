#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      # Parser for the whois.ibi.net server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisIbiNet < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /^Above domain name is not registered to/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Record created on\.+:\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Record last updated on\.+:\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Record expires on\.+:\s+(.+)\n/
            Time.parse($1)
          end
        end

        # For .ibi.net domains registrant contacts, only name and address
        # were available.
        property_supported :registrant_contacts do
          if content_for_scanner =~ /Registrant :\n((.+\n)+)\n/
            lines = $1.split("\n").map(&:strip)
            name = lines[0]
            address = lines[1]
            Record::Contact.new(
                :type         => Whois::Record::Contact::TYPE_REGISTRANT,
                :name         => name,
                :address      => address,
                :city         => nil,
                :zip          => nil,
                :state        => nil,
                :country_code => nil,
                :phone        => nil,
                :fax          => nil,
                :email        => nil
            ) 
          end
        end

        
        # For .ibi.net domains administrative contacts, only name and address
        # were available.
        property_supported :admin_contacts do
          if content_for_scanner =~ /Administrative Contact\s:\n((.+\n)+)\n/
            lines = $1.split("\n").map(&:strip)
            name_email = lines[0].split("  ").map(&:strip)
            name = name_email[0]
            email = name_email[1]
            address = lines[1]
            phone = lines[2]
            Record::Contact.new(
                :type         => Whois::Record::Contact::TYPE_ADMINISTRATIVE,
                :name         => name,
                :address      => address,
                :city         => nil,
                :zip          => nil,
                :state        => nil,
                :country_code => nil,
                :phone        => phone,
                :fax          => nil,
                :email        => email
            ) 
          end
        end
        
        # For .ibi.net domains technical contacts, only name and address
        # were available.
        property_supported :technical_contacts do
          if content_for_scanner =~ /Technical Contact\s:\n((.+\n)+)\n/
            lines = $1.split("\n").map(&:strip)
            name_email = lines[0].split("  ").map(&:strip)
            name = name_email[0]
            email = name_email[1]
            address = lines[1]
            phone = lines[2]
            Record::Contact.new(
                :type         => Whois::Record::Contact::TYPE_TECHNICAL,
                :name         => name,
                :address      => address,
                :city         => nil,
                :zip          => nil,
                :state        => nil,
                :country_code => nil,
                :phone        => phone,
                :fax          => nil,
                :email        => email
            ) 
          end
        end

        property_supported :nameservers do
          content_for_scanner.scan(/Domain Name Servers in listed order:\n((.+\n)+)\n/).flatten.map do |group|
            $1.to_s.split("\n").reject { |value| value =~ /No name servers listed/ }.map do |line|
              name = line.to_s.strip
              Record::Nameserver.new(:name => name)
            end
          end
        end

      end

    end
  end
end
