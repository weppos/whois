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

        register_method :status do
          @status ||= if content.to_s =~ /Status:\s(.*?)[\r\n]+/
            $1.downcase.to_sym
          end
        end

        register_method :available? do
          !registered?
        end

        register_method :registered? do
          @registered ||= (content.to_s =~ /Domain Name:/)
        end


        # TODO: NotAvailable
        register_method :created_on do
          nil
        end
        
        # TODO: NotAvailable
        register_method :updated_on do
          nil
        end
        
        # TODO: NotAvailable
        register_method :expires_on do
          nil
        end

      end
      
    end
  end
end  