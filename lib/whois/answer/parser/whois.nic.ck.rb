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
      # = whois.nic.ck parser
      #
      # Parser for the whois.nic.ck server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicCk < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
           !!(content_for_scanner =~ /^% No entries found for the selected source/)
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_supported :updated_on do
          if content_for_scanner =~ /changed:\s+(.*)\n/
            Time.parse($1.split(" ", 2).last)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /remarks:\s+expires (.+)\n/
            Time.parse($1)
          end
        end


        property_supported :nameservers do # TODO
          content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten
        end

      end

    end
  end
end
