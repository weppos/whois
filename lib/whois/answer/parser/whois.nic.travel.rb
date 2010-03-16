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
      # = whois.nic.travel parser
      #
      # Parser for the whois.nic.travel server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicTravel < Base

        property_supported :status do
          @status ||= content_for_scanner.scan(/Domain Status:\s+(.*?)\n/).flatten
        end

        property_supported :available? do
          @available ||= !!(content_for_scanner =~ /Not found:/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          @created_on ||= if content_for_scanner =~ /Domain Registration Date:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          @updated_on ||= if content_for_scanner =~ /Domain Last Updated Date:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          @expires_on ||= if content_for_scanner =~ /Domain Expiration Date:\s+(.*)\n/
            Time.parse($1)
          end
        end


        property_supported :nameservers do
          @nameservers ||= content_for_scanner.scan(/Name Server:\s+(.+)\n/).flatten.map(&:downcase)
        end

      end

    end
  end
end
