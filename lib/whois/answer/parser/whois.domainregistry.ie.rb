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

        register_method :status do
          @status ||= if content.to_s =~ /status:\s+(.*)\n/
            $1.downcase.to_sym
          else
            :available
          end
        end

        register_method :available? do
          @available ||= !!(content.to_s =~ /Not Registered - The domain you have requested is not a registered .ie domain name/)
        end

        register_method :registered? do
          !available?
        end


        # TODO: NotAvailable
        register_method :created_on do
          nil
        end
        
        # TODO: NotAvailable
        register_method :updated_on do
          nil
        end
        
        register_method :expires_on do
          @expires_on ||= if content.to_s =~ /renewal:\s+(.*)\n/
            Time.parse($1)
          end
        end

      end
      
    end
  end
end  