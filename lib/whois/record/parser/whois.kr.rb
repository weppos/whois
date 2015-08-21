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

      # Parser for the whois.kr server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisKr < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /^Above domain name is not registered to KRNIC/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Registered Date\s+:\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Last Updated Date\s+:\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Expiration Date\s+:\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_supported :domain do
          if content_for_scanner =~ /Domain Name\s+:(.+)\n/
            $1.downcase.strip
          end
        end

        # For .kr domains registrant contacts, only name, address, and zip code were
        # available.
        property_supported :registrant_contacts do
          Record::Contact.new(
              :type         => Whois::Record::Contact::TYPE_REGISTRANT,
              :name         => content_for_scanner[/Registrant\s+:(.+?)\n/, 1].to_s.strip,
              :address      => content_for_scanner[/Registrant Address\s+:(.+?)\n/, 1].to_s.strip,
              :city         => nil,
              :zip          => content_for_scanner[/Registrant Zip Code\s+:(.+?)\n/, 1].to_s.strip,
              :state        => nil,
              :country_code => nil,
              :phone        => nil,
              :fax          => nil,
              :email        => nil
          ) 
        end
        
        # For .kr domains administrative contacts, only name, email, and phone were
        # available.
        property_supported :admin_contacts do
          Record::Contact.new(
              :type         => Whois::Record::Contact::TYPE_ADMINISTRATIVE,
              :name         => content_for_scanner[/Administrative Contact\(AC\)\s+:(.+?)\n/, 1].to_s.strip,
              :address      => nil,
              :city         => nil,
              :zip          => nil,
              :state        => nil,
              :country_code => nil,
              :phone        => content_for_scanner[/AC Phone Number\s+:(.+?)\n/, 1].to_s.strip,
              :fax          => nil,
              :email        => content_for_scanner[/AC E-Mail\s+:(.+?)\n/, 1].to_s.strip
          ) 
        end

        property_supported :nameservers do
          content_for_scanner.scan(/^\w+ Name Server\n((?:.+\n)+)\n/).flatten.map do |group|
            Record::Nameserver.new.tap do |nameserver|
              if group =~ /\s+Host Name\s+:\s+(.+)\n/
                nameserver.name = $1
              end
              if group =~ /\s+IP Address\s+:\s+(.+)\n/
                nameserver.ipv4 = $1
              end
            end
          end
        end

      end

    end
  end
end
