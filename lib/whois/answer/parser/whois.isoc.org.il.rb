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
      # = whois.isoc.org.il parser
      #
      # Parser for the whois.isoc.org.il server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisIsocOrgIl < Base

        property_supported :status do
          @status ||= if content_for_scanner =~ /status:\s+(.*?)\n/
            case $1.downcase
              when "transfer locked" then :registered
              else
                Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          @available  ||= (status == :available)
        end

        property_supported :registered? do
          @registered ||= !available?
        end


        # TODO: first changed record
        property_not_supported :created_on

        property_supported :updated_on do
          @updated_on ||= if content_for_scanner =~ /changed:\s+(.+)\n/
            t = content_for_scanner.scan(/changed:\s+(?:.+?) (\d+) \(Changed\)\n/).flatten.last
            Time.parse(t)
          end
        end

        property_not_supported :expires_on


        property_supported :nameservers do
          @nameservers ||= content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten.map { |value| value.split(" ").first }
        end

      end

    end
  end
end
