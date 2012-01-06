#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      #
      # = whois.dns.pt parser
      #
      # Parser for the whois.dns.pt server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisDnsPt < Base

        property_supported :status do
          if content_for_scanner =~ /^Estado \/ Status:\s+(.+)\n/
            case $1.downcase
              when "active"   then :registered
              when "reserved" then :reserved
              when "tech-pro" then :inactive
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
          content_for_scanner.scan(/Nameserver:\s(?:.+\t)?(.+?)\.\n/).flatten.map do |name|
            Record::Nameserver.new(name)
          end
        end

      end

    end
  end
end
