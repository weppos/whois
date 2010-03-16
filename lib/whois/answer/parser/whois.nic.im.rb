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
      # = whois.nic.im parser
      #
      # Parser for the whois.nic.im server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicIm < Base

        property_supported :status do
          @status ||= if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          @available ||= !!(content_for_scanner =~ /was not found/)
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_not_supported :updated_on

        property_supported :expires_on do
          @expires_on ||= if content_for_scanner =~ /Expiry Date:\s+(.*?)\n/
            Time.parse($1.gsub("/", "-"))
          end
        end


        property_supported :nameservers do
          @nameservers ||= content_for_scanner.scan(/Name Server:\s(.*)\n/).flatten.map { |value| value.chomp(".") }
        end

      end

    end
  end
end
