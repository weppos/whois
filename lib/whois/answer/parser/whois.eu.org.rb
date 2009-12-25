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
      # = whois.eu.org parser
      #
      # Parser for the whois.eu.org server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisEuOrg < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          @available ||= !!(content.to_s =~ /Key not found/)
        end

        property_supported :registered? do
          !available?
        end


        # TODO: NotAvailable (or anniversary?)
        property_supported :created_on do
          nil
        end
        
        # TODO: NotAvailable (or anniversary?)
        property_supported :updated_on do
          nil
        end
        
        # TODO: NotAvailable (or anniversary?)
        property_supported :expires_on do
          nil
        end

      end
      
    end
  end
end  