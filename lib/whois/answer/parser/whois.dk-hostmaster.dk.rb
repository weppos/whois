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
      # = whois.dk-hostmaster.dk
      #
      # Parser for the whois.dk-hostmaster.dk server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisDkHostmasterDk < Base

        property_supported :status do
          @status ||= if content.to_s =~ /Status:\s+(.*)\n/
            $1.downcase.to_sym
          end
        end

        property_supported :available? do
          @available ||= !!(content.to_s =~ /No entries found for the selected source/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          @created_on ||= if content.to_s =~ /Registered:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          @expires_on ||= if content.to_s =~ /Expires:\s+(.*)\n/
            Time.parse($1)
          end
        end


        property_supported :nameservers do
          @nameservers ||= content.to_s.scan(/Hostname:\s+(.*)\n/).flatten! || []
        end

      end
      
    end
  end
end  