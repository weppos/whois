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
      # = whois.domainregistry.ie parser
      #
      # Parser for the whois.domainregistry.ie server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisDomainregistryIe < Base

        property_supported :status do
          @status ||= if content_for_scanner =~ /status:\s+(.*)\n/
            $1.downcase.to_sym
          else
            :available
          end
        end

        property_supported :available? do
          @available ||= !!(content_for_scanner =~ /Not Registered - The domain you have requested is not a registered .ie domain name/)
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_not_supported :updated_on

        property_supported :expires_on do
          @expires_on ||= if content_for_scanner =~ /renewal:\s+(.*)\n/
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
