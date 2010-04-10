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
      # = whois.za.org parser
      #
      # Parser for the whois.za.org server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisZaOrg < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          @available ||= !!(content_for_scanner =~ /No such domain:/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          @created_on ||= if content_for_scanner =~ /Record Created\s+:\s+(.*)\n/
            Time.parse($1)
          end
        end
        
        property_supported :updated_on do
          @updated_on ||= if content_for_scanner =~ /Record Last Updated\s+:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_not_supported :expires_on


        property_supported :nameservers do
          @nameservers ||= if content_for_scanner =~ /Domain Name Servers listed in order:\n\n((.+\n)+)\n/
            $1.split("\n").map(&:strip).reject(&:empty?).compact
          else
            []
          end
        end

      end

    end
  end
end
