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

      # Parser for the whois.dns.pt server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisDnsPt < Base

        property_supported :status do
          if content_for_scanner =~ /^Estado \/ Status:\s+(.+)\n/
            case $1.downcase
            when "active"
              :registered
            when "reserved"
              :reserved
            when "tech-pro"
              :inactive
            else
              Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /^.* no match$/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ / Creation Date .+?:\s+(.+)\n/
            Time.utc(*$1.split("/").reverse)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ / Expiration Date .+?:\s+(.+)\n/
            Time.utc(*$1.split("/").reverse)
          end
        end


        property_supported :nameservers do
          content_for_scanner.scan(/Nameserver:\s+(?:.*)\s+NS\s+(.+?)\.\n/).flatten.map do |name|
            Record::Nameserver.new(:name => name)
          end
        end

      end

    end
  end
end
