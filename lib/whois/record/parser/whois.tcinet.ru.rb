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

      # Parser for the whois.tcinet.ru server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisTcinetRu < Base

        property_supported :domain do
          if content_for_scanner =~ /domain:\s+(.+?)\n/
            $1.downcase
          end
        end

        property_not_supported :domain_id


        property_supported :status do
          if content_for_scanner =~ /state:\s+(.+?)\n/
            $1.split(",").map(&:strip)
          else
            []
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /No entries found/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /created:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /paid-till:\s+(.*)\n/
            Time.parse($1)
          end
        end


        property_supported :registrar do
          if content_for_scanner =~ /registrar:\s+(.*)\n/
            Record::Registrar.new(
                :id           => $1
            )
          end
        end


        property_supported :admin_contacts do
          url   = content_for_scanner[/admin-contact:\s+(.+)\n/, 1]
          email = content_for_scanner[/e-mail:\s+(.+)\n/, 1]
          contact = if url or email
            Record::Contact.new(
              :type         => Record::Contact::TYPE_ADMINISTRATIVE,
              :url          => url,
              :email        => email,
              :name         => content_for_scanner[/person:\s+(.+)\n/, 1],
              :organization => content_for_scanner[/org:\s+(.+)\n/, 1],
              :phone        => content_for_scanner[/phone:\s+(.+)\n/, 1],
              :fax          => content_for_scanner[/fax-no:\s+(.+)\n/, 1]
            )
          end
          Array.wrap(contact)
        end

        property_not_supported :registrant_contacts

        property_not_supported :technical_contacts


        # Nameservers are listed in the following formats:
        #
        #   nserver:     ns.masterhost.ru.
        #   nserver:     ns.masterhost.ru. 217.16.20.30
        #
        property_supported :nameservers do
          content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten.map do |line|
            name, ipv4 = line.split(/\s+/)
            Record::Nameserver.new(:name => name.chomp("."), :ipv4 => ipv4)
          end
        end

      end

    end
  end
end
