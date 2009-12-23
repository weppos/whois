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
      # = whois.nic.gl parser
      #
      # Parser for the whois.nic.gl server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicGl < Base

        register_method :status do
          @status ||= if content.to_s =~ /Status:\s+(.*?)\n/
            case $1.downcase.to_sym
              when :"active"          then :registered
              when :"not registered"  then :available
            end
          end
        end

        register_method :available? do
          @available ||= (status == :available)
        end

        register_method :registered? do
          !available?
        end


        register_method :created_on do
          @created_on ||= if content.to_s =~ /Created:\s+(.*?)\n/
            Time.parse($1)
          end
        end
        
        register_method :updated_on do
          @updated_on ||= if content.to_s =~ /Modified:\s+(.*?)\n/
            Time.parse($1)
          end
        end
        
        register_method :expires_on do
          @expires_on ||= if content.to_s =~ /Expires:\s+(.*?)\n/
            Time.parse($1)
          end
        end

      end
      
    end
  end
end  