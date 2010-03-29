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
      # = whois.nic.at parser
      #
      # Parser for the whois.nic.at server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicAt < Base

        property_supported :status do
          @status ||= if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          @available ||= !!(content_for_scanner =~ /% nothing found/)
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_supported :updated_on do
          @updated_on ||= if content_for_scanner =~ /changed:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_not_supported :expires_on


        property_supported :nameservers do
          @nameservers ||= content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten
        end

      end

    end
  end
end
