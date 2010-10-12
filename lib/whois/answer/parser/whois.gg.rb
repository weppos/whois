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
      # = whois.gg parser
      #
      # Parser for the whois.gg server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisGg < Base

        property_supported :status do
          @status ||= if content_for_scanner =~ /status:(.+?)\n/
            case $1.downcase
              when "0"              then :available
              when "1"              then :registered
              else
                raise ParserError, "Unknown status `#{$1}'. " <<
                      "Please report the issue at http://github.com/weppos/whois/issues"
            end
          else
            raise ParserError, "Unable to parse status. " <<
                  "Please report the issue at http://github.com/weppos/whois/issues"
          end
        end

        property_supported :available? do
          @available  ||= !!(content_for_scanner =~ /^\*\* No information found in WHOIS \*\*$/)
        end

        property_supported :registered? do
          @registered ||= !available?
        end


        property_not_supported :created_on

        property_not_supported :updated_on

        property_not_supported :expires_on


        property_supported :nameservers do
          @nameservers ||= if content_for_scanner =~ /Registered Nameservers\n[-]+\n((.+\n)+)\n/
            $1.split("\n").map { |value| value.chomp(".") }
          else
            []
          end
        end

      end

    end
  end
end
