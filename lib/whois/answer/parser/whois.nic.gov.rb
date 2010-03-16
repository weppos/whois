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
      # = whois.nic.gov parser
      #
      # Parser for the whois.nic.gov server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicGov < Base

        property_supported :status do
          @status ||= if content_for_scanner =~ /Status:\s(.*?)\n+/
            $1.downcase.to_sym
          end
        end

        property_supported :available? do
          !registered?
        end

        property_supported :registered? do
          @registered ||= (content_for_scanner =~ /Domain Name:/)
        end


        property_not_supported :created_on

        property_not_supported :updated_on

        property_not_supported :expires_on


        property_not_supported :nameservers

      end

    end
  end
end
