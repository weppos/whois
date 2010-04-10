#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
#
# Category::    Net
# Package::     Whois
# Author::      Mikkel Kristensen <mikkel@tdx.dk>, Simone Carletti <weppos@weppos.net>
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
      # = whois.nic.nu
      #
      # Parser for the whois.nic.nu server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicNu < Base

        property_supported :status do
          @status ||= if content_for_scanner =~ /Record status:\s+(.*)\n/
            $1.downcase.to_sym
          end
        end

        property_supported :available? do
          @available ||= !!(content_for_scanner =~ /NO MATCH for domain/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          @created_on ||= if content_for_scanner =~ /Record created on (.*).\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          @updated_on ||= if content_for_scanner =~ /Record last updated on (.*?).\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          @expires_on ||= if content_for_scanner =~ /Record expires on (.*).\n/
            Time.parse($1)
          end
        end


        property_supported :nameservers do
          @nameservers ||= if content_for_scanner =~ /Domain servers in listed order:(.*)Owner and Administrative Contact information for domains/m
            $1.split.map(&:strip)
          else
            []
          end
        end

      end

    end
  end
end