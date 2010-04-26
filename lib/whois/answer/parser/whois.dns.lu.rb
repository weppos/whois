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
      # = whois.dns.lu parser
      #
      # Parser for the whois.dns.lu server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisDnsLu < Base

        property_supported :status do
          @status ||= if content_for_scanner =~ /domaintype:\s+(.*)\n/
            $1
          end
        end

        property_supported :available? do
          @available ||= !!(content_for_scanner =~ /% No such domain/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          @created_on ||= if content_for_scanner =~ /registered:\s+(.*)\n/
            # Force the parser to use the dd/mm/yyyy format.
            Time.utc(*$1.split("/").reverse)
          end
        end

        property_not_supported :updated_on

        property_not_supported :expires_on


        property_supported :nameservers do
          @nameservers ||= content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten.map { |value| value.split(" ").first }
        end

      end

    end
  end
end
