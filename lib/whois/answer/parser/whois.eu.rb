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
      # = whois.eu parser
      #
      # Parser for the whois.eu server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisEu < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          @available ||= !!(content_for_scanner =~ /Status:\s+AVAILABLE/)
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_not_supported :updated_on

        property_not_supported :expires_on


        # Nameservers are listed in the following formats:
        # 
        #   Nameservers:
        #           dns1.servicemagic.eu
        #           dns2.servicemagic.eu
        #   
        #   Nameservers:
        #           dns1.servicemagic.eu (91.121.133.61)
        #           dns2.servicemagic.eu (91.121.103.77)
        # 
        # In both cases, always return only the name.
        property_supported :nameservers do
          @nameservers ||= if content_for_scanner =~ /Nameservers:\n((.+\n)+)\n/
            $1.split("\n").map { |value| value.strip.split(" ").first }
          else
            []
          end
        end

      end

    end
  end
end
