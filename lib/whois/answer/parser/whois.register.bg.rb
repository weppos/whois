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
      # = whois.register.bg parser
      #
      # Parser for the whois.register.bg server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisRegisterBg < Base

        property_supported :status do
          @status ||= if content.to_s =~ /registration status:\s+(.*?)\n/
            $1.downcase.to_sym
          end
        end

        property_supported :available? do
          @available ||= (content.to_s =~ /Domain name (.+?) does not exist/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          @created_on ||= if content.to_s =~ /activated on:\s+(.*?)\n/
            # Time.parse("30/06/2003 00:00:00")
            # => ArgumentError: argument out of range
            Time.parse($1.gsub("/", "-"))
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          @expires_on ||= if content.to_s =~ /expires at:\s+(.*?)\n/
            # Time.parse("30/06/2003 00:00:00")
            # => ArgumentError: argument out of range
            Time.parse($1.gsub("/", "-"))
          end
        end

      end
      
    end
  end
end  