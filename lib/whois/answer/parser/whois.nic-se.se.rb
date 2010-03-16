#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
#
# Category::    Net
# Package::     Whois
# Author::      Mikkel Kristensen <mikkel@tdx.dk>, Simone Carletti <weppos@weppos.net>
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
      # = whois.nic-se.se
      #
      # Parser for the whois.nic-se.se server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicSeSe < Base

        property_supported :status do
          @status ||= if content_for_scanner =~ /state:\s+(.*)\n/
            $1.downcase.to_sym
          end
        end

        property_supported :available? do
          @available ||= !!(content_for_scanner =~ /" not found./)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          @created_on ||= if content_for_scanner =~ /created:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          @expires_on ||= if content_for_scanner =~ /expires:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          @updated_on ||= if content_for_scanner =~ /modified:\s+(.*?)\n/
            Time.parse($1)
          end
        end


        # Nameservers are listed in the following formats:
        # 
        #   nserver:  ns2.loopia.se
        #   nserver:  ns2.loopia.se 93.188.0.21
        # 
        # In both cases, always return only the name.
        property_supported :nameservers do
          @nameservers ||= content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten.map { |value| value.split(" ").first }
        end

      end

    end
  end
end