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
          @status ||= if content_for_scanner =~ / Status:\s+(.*)\n/
            $1
          end
        end

        property_supported :available? do
          @available ||= !!(content_for_scanner =~ /^.* no match$/)
        end

        property_supported :registered? do
          @registered ||= !available?
        end


        property_supported :created_on do
          @created_on ||= if content_for_scanner =~ / Creation Date .+?:\s+(.*)\n/
            DateTime.strptime($1, "%d/%m/%Y").to_time
          end
        end

        property_not_supported :updated_on

        property_not_supported :expires_on


        property_supported :nameservers do
          @nameservers ||= content_for_scanner.scan(/Nameserver:\s+(.+)\n/).flatten.map { |value| value.chomp(".") }
        end

      end

    end
  end
end
