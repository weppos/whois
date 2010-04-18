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
      # = whois.nic.mx parser
      #
      # Parser for the whois.nic.mx server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicMx < Base

        property_supported :status do
          @status ||= if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          @available ||= !!(content_for_scanner =~ /Object_Not_Found/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          @created_on ||= if content_for_scanner =~ /Created On:\s+(.*)\n/
            Time.parse($1)
          end
        end

        # FIXME: the response contains localized data
        # Expiration Date: 10-may-2011
        # Last Updated On: 15-abr-2010 <--
        # property_supported :updated_on do
        #   @updated_on ||= if content_for_scanner =~ /Last Updated On:\s+(.*)\n/
        #     Time.parse($1)
        #   end
        # end

        property_supported :expires_on do
          @expires_on ||= if content_for_scanner =~ /Expiration Date:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :nameservers do
          @nameservers ||= if content_for_scanner =~ /Name Servers:\n((.+\n)+)\n/
            $1.scan(/DNS:\s+(.*)\n/).flatten.map(&:strip)
          else
            []
          end
        end

      end

    end
  end
end
