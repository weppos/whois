#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2011 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      #
      # = whois.ripn.net parser
      #
      # Parser for the whois.ripn.net server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisRipnNet < Base

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
            Record::Registrar.new(:id => $1)
          end
        end


        property_supported :admin_contacts do
          content_for_scanner.scan(/e-mail:\s+(.+)\n/).flatten.map do |email|
            Record::Contact.new(
              :type         => Record::Contact::TYPE_ADMIN,
              :name         => content_for_scanner[/person:\s+(.+)\n/, 1],
              :organization => content_for_scanner[/org:\s+(.+)\n/, 1],
              :phone        => content_for_scanner[/phone:\s+(.+)\n/, 1],
              :fax          => content_for_scanner[/fax-no:\s+(.+)\n/, 1],
              :email        => email
            )
          end
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
            Record::Nameserver.new(name.chomp("."), ipv4)
          end
        end

      end

    end
  end
end
