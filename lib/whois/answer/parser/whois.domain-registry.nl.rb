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
      # = whois.domain-registry.nl parser
      #
      # Parser for the whois.domain-registry.nl server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisDomainRegistryNl < Base

        property_supported :status do
          @status ||= if content_for_scanner =~ /Status:\s+(.*?)\n/
            case $1.downcase
              when "active"         then :registered
              when "in quarantine"  then :quarantine
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
          @registered ||= [:registered, :quarantine].include?(status)
        end


        property_supported :created_on do
          @created_on ||= if content_for_scanner =~ /Date registered:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          @updated_on ||= if content_for_scanner =~ /Record last updated:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_not_supported :expires_on


        property_supported :nameservers do
          @nameservers ||= if content_for_scanner =~ /Domain nameservers:\n((.+\n)+)\n/
            $1.split("\n").map { |value| value.strip.split(/\s+/).first }
          else
            []
          end
        end

      end

    end
  end
end
