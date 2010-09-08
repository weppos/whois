#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
#
# Category::    Net
# Package::     Whois
# Author::      Moritz Heidkamp <moritz.heidkamp@bevuta.com>
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
      # = whois.co.ug parser
      #
      # Parser for the whois.co.ug server.
      #
      class WhoisCoUg < Base

        property_supported :status do
          @status ||= content_for_scanner[/^Status:\s+(.+)$/, 1]
        end

        property_supported :available? do
          @available ||= !!(content_for_scanner =~ /No entries found for the selected source/)
        end

        property_supported :registered? do
          !available?
        end

        property_supported :created_on do
          @created_on ||= if content_for_scanner =~ /Registered:\s+(.+)$/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          @updated_on ||= if content_for_scanner =~ /Updated:\s+(.+)$/
            DateTime.strptime($1, '%d/%m/%Y %H:%M:%S %Z')
          end
        end

        property_supported :expires_on do
          @expires_on ||= if content_for_scanner =~ /Expiry:\s(.+)$/
            Time.parse($1)
          end
        end


        property_supported :nameservers do
          @nameservers ||= content_for_scanner.scan(/Nameserver:\s+(.+)$/).flatten.map(&:downcase)
        end

      end

    end
  end
end
