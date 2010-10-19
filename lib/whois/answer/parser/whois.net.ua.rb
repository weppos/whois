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
      # = whois.net.ua parser
      #
      # Parser for the whois.net.ua server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNetUa < Base

        property_supported :status do
          @status ||= if content_for_scanner =~ /status:\s+(.+?)\n/
            case $1.downcase
              when /^ok-until/ then :registered
              else
                Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          @available ||= !!(content_for_scanner =~ /No entries found for domain/)
        end

        property_supported :registered? do
          @registered ||= !available?
        end


        property_not_supported :created_on

        property_supported :updated_on do
          @updated_on ||= if content_for_scanner =~ /changed:\s+(.*)\n/
            time = $1.split(" ").last
            DateTime.strptime(time, "%Y%m%d%H%M%S").to_time
          end
        end

        property_supported :expires_on do
          @expires_on ||= if content_for_scanner =~ /status:\s+(.*)\n/
            time = $1.split(" ").last
            DateTime.strptime(time, "%Y%m%d%H%M%S").to_time
          end
        end


        property_supported :nameservers do
          @nameservers ||= content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten.map { |value| value.strip.downcase }
        end

      end

    end
  end
end
