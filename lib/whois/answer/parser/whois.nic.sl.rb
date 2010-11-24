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
      # = whois.nic.sl parser
      #
      # Parser for the whois.nic.sl server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicSl < Base

        property_supported :status do
          @status ||= if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          @available  ||= !!(content_for_scanner =~ /Domain not found, marked private, or error in your query/)
        end

        property_supported :registered? do
          @registered ||= !available?
        end


        property_supported :created_on do
          @created_on ||= if content_for_scanner =~ /^Registration Date:\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          @expires_on ||= if content_for_scanner =~ /^Last Updated:\s+(.+)\n/
            if $1 != "0000-00-00"
              Time.parse($1)
            end
          end
        end

        property_supported :expires_on do
          @expires_on ||= if content_for_scanner =~ /^Expiration Date:\s+(.+)\n/
            Time.parse($1)
          end
        end


        property_supported :nameservers do
          @nameservers ||= content_for_scanner.scan(/^Name Server:\s+(.+)\n/).flatten.map(&:downcase)
        end

      end

    end
  end
end
