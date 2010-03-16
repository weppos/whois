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
      # = whois.nic.coop parser
      #
      # Parser for the whois.nic.coop server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicCoop < Base

        property_supported :status do
          @status ||= if content_for_scanner =~ /Status:\s+(.*)\n/
            $1.downcase.to_sym
          end
        end

        property_supported :available? do
          @available ||= !!(content_for_scanner =~ /No domain records were found to match/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          @created_on ||= if content_for_scanner =~ /Created:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          @updated_on ||= if content_for_scanner =~ /Last updated:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          @expires_on ||= if content_for_scanner =~ /Expiry Date:\s+(.*)\n/
            Time.parse($1)
          end
        end


        property_supported :nameservers do
          @nameservers ||= content_for_scanner.scan(/Host Name:\s+(.+)\n/).flatten
        end

      end

    end
  end
end
