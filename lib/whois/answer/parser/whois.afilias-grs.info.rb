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
      # = whois.afilias-grs.info parser
      #
      # Parser for the whois.afilias-grs.info server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisAfiliasGrsInfo < Base

        register_method :status do
          @status ||= content.to_s.scan(/Status:(.*?)[\r\n]+/).flatten
        end

        register_method :available? do
          @available ||= (content.to_s.strip == "NOT FOUND")
        end

        register_method :registered? do
          !available?
        end


        register_method :created_on do
          @created_on ||= if content.to_s =~ /Created On:(.*?)[\r\n]+/
            Time.parse($1)
          end
        end
        
        register_method :updated_on do
          @updated_on ||= if content.to_s =~ /Last Updated On:(.*?)[\r\n]+/
            Time.parse($1)
          end
        end
        
        register_method :expires_on do
          @expires_on ||= if content.to_s =~ /Expiration Date:(.*?)[\r\n]+/
            Time.parse($1)
          end
        end

      end
      
    end
  end
end  