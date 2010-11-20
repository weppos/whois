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
      # = whois.jprs.jp parser
      #
      # Parser for the whois.jprs.jp server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisJprsJp < Base

        property_supported :status do
          @status ||= if content_for_scanner =~ /\[Stat(?:us|e)\]\s+(.*)\n/
            case $1.split(" ").first.downcase
              when "active" then :registered
              when "connected" then :registered
              else
                Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          @available  ||= !!(content_for_scanner =~ /No match!!/)
        end

        property_supported :registered? do
          @registered ||= !available?
        end


        # TODO: timezone ('Asia/Tokyo')
        property_supported :created_on do
          @created_on ||= if content_for_scanner =~ /\[(?:Created on|Registered Date)\][ \t]+(.*)\n/
            ($1.empty?) ? nil : Time.parse($1)
          end
        end

        # TODO: timezone ('Asia/Tokyo')
        property_supported :updated_on do
          @updated_on ||= if content_for_scanner =~ /\[Last Updated?\][ \t]+(.*)\n/
            ($1.empty?) ? nil : Time.parse($1)
          end
        end

        # TODO: timezone ('Asia/Tokyo')
        property_supported :expires_on do
          @expires_on ||= if content_for_scanner =~ /\[Expires on\][ \t]+(.*)\n/
            ($1.empty?) ? nil : Time.parse($1)
          end
        end


        property_supported :nameservers do
          @nameservers ||= content_for_scanner.scan(/\[Name Server\][ \t]+(.*?)\n/).flatten
        end

      end

    end
  end
end
