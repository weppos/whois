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
      # = whois.dns.be parser
      #
      # Parser for the whois.dns.be server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisDnsBe < Base

        property_supported :status do
          @status ||= if content_for_scanner =~ /Status:\s+(.+)\n/
            $1
          end
        end

        property_supported :available? do
          @available ||= (status == "FREE")
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          @created_on ||= if content_for_scanner =~ /Registered:\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_not_supported :expires_on


        property_supported :nameservers do
          @nameservers ||= if content_for_scanner =~ /Nameservers:\n((.+\n)+)\n/
            $1.split("\n").map(&:strip)
          else
            []
          end
        end

      end

    end
  end
end
