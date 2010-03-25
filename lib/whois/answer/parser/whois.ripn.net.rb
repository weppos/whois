#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
#
# Category::    Net
# Package::     Whois
# Author::      Simone Carletti <weppos@weppos.net>
# License::     MIT License
#
#--
#
#++


require 'whois/answer/parser/base'


module Whois
  class Answer
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
          @status ||= if content_for_scanner =~ /state:\s+(.*?)\n/
            $1.split(",").map(&:strip)
          else
            []
          end
        end

        property_supported :available? do
          @available ||= !!(content_for_scanner =~ /No entries found/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          @created_on ||= if content_for_scanner =~ /created:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          @expires_on ||= if content_for_scanner =~ /paid-till:\s+(.*)\n/
            Time.parse($1)
          end
        end


        # Nameservers are listed in the following formats:
        # 
        #   nserver:     ns.masterhost.ru.
        #   nserver:     ns.masterhost.ru. 217.16.20.30
        # 
        # In both cases, always return only the name.
        property_supported :nameservers do
          @nameservers ||= content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten.map { |value| value.split(" ").first.chomp(".") }
        end

      end

    end
  end
end
