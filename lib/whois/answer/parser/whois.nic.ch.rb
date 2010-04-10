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
      # = whois.nic.ch parser
      #
      # Parser for the whois.nic.ch server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicCh < Base

        property_supported :status do
          @status ||= if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          @available ||= (content_for_scanner =~ /We do not have an entry/)
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_not_supported :updated_on

        property_not_supported :expires_on


        # Nameservers are listed in the following formats:
        # 
        #   ns1.citrin.ch
        #   ns1.citrin.ch  [193.247.72.8]
        # 
        # In both cases, always return only the name.
        property_supported :nameservers do
          @nameservers ||= if content_for_scanner =~ /Name servers:\n((.+\n)+)(?:\n|\z)/
            $1.split("\n").map { |value| value.split("\t").first }.uniq
          else
            []
          end
        end

      end

    end
  end
end
