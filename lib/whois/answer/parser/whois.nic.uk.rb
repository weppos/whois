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
      # = whois.nic.uk parser
      #
      # Parser for the whois.nic.uk server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicUk < Base

        property_supported :status do
          @status ||= if content.to_s =~ /\s+Registration status:\s+\n(.*?)\n/
            $1.strip
          end
        end

        property_supported :available? do
          @available ||= !!(content.to_s =~ /This domain name has not been registered/)
        end

        property_supported :registered? do
          !available?
        end

        def valid?
          !invalid?
        end

        def invalid?
          @invalid ||= !!(content.to_s =~ /This domain cannot be registered/)
        end


        property_supported :created_on do
          @created_on ||= if content.to_s =~ /\s+Registered on:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          @updated_on ||= if content.to_s =~ /\s+Last updated:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          @expires_on ||= if content.to_s =~ /\s+Renewal date:\s+(.*)\n/
            Time.parse($1)
          end
        end

      end
      
    end
  end
end  