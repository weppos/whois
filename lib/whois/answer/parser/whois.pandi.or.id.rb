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
      # = whois.pandi.or.id parser
      #
      # Parser for the whois.pandi.or.id server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisPandiOrId < Base

        property_supported :status do
          @status ||= if content_for_scanner =~ /domain-status:\s+(.*)\n/
            $1
          end
        end

        property_supported :available? do
          @available ||= !!(content_for_scanner =~ /%ERROR:101: no entries found/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          @created_on ||= if content_for_scanner =~ /created:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          @updated_on ||= if content_for_scanner =~ /last-update:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          @expires_on ||= if content_for_scanner =~ /expires:\s+(.*)\n/
            Time.parse($1)
          end
        end


        property_supported :nameservers do
          @nameservers ||= content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten
        end

      end

    end
  end
end
