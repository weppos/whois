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

      # Parser for the whois.eu server.
      #
      class WhoisEu < Base

        property_supported :domain do
          if content_for_scanner =~ /Domain:\s+(.+)\n/
            "#{$1.downcase}.eu"
          end
        end

        property_not_supported :domain_id


        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /Status:\s+AVAILABLE/)
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_not_supported :updated_on

        property_not_supported :expires_on


        property_supported :registrar do
          if content_for_scanner =~ /Registrar:\s((.+\n)+)\n/
            lines = $1
            Record::Registrar.new(
                name:         lines.slice(/Name:\s+(.+)/, 1),
                url:          lines.slice(/Website:\s+(.+)/, 1)
            )
          end
        end

        property_not_supported :registrant_contacts

        property_not_supported :admin_contacts

        # Technical Contact
        #
        # Technical:
        # Name: DNS Admin
        # Organisation: Google Inc.
        # Language: en
        # Phone: +1.6506234000
        # Fax: +1.6506188571
        # Email: dns-admin@google.com
        #
        property_supported :technical_contacts do
          if content_for_scanner =~ /Technical:\s((.+\n)+)\n/
            lines = $1
            Record::Contact.new(
              :type         => Record::Contact::TYPE_TECHNICAL,
              :id           => nil,
              :name         => lines.slice(/Name:\s*(.*)/, 1),
              :organization => lines.slice(/Organisation:\s*(.*)/, 1),
              :phone        => lines.slice(/Phone:\s*(.*)/, 1),
              :fax          => lines.slice(/Fax:\s*(.*)/, 1),
              :email        => lines.slice(/Email:\s*(.*)/, 1)
            )
          end
        end


        # Nameservers are listed in the following formats:
        #
        #   Name servers:
        #   dns1.servicemagic.eu
        #   dns2.servicemagic.eu
        #
        #   Name servers:
        #   dns1.servicemagic.eu (91.121.133.61)
        #   dns2.servicemagic.eu (91.121.103.77)
        #
        property_supported :nameservers do
          if content_for_scanner =~ /Name\sservers:\s((.+\n)+)\n/
            $1.split("\n").map do |line|
              if line.strip =~ /(.+) \((.+)\)/
                Record::Nameserver.new(:name => $1, :ipv4 => $2)
              else
                Record::Nameserver.new(:name => line.strip)
              end
            end
          end
        end


        # Checks whether the response has been throttled.
        #
        # @return [Boolean]
        #
        # @example
        #   -1: Still in grace period, wait 7777777 seconds
        #
        def response_throttled?
          !!(content_for_scanner =~ /Still in grace period/)
        end

      end

    end
  end
end
