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
      # = whois.nic.fr parser
      #
      # Parser for the whois.nic.fr server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicFr < Base

        register_method :status do
          @status ||= if content.to_s =~ /status:\s+(.*)\n/
            $1.downcase.to_sym
          else
            :available
          end
        end

        register_method :available? do
          @available ||= !!(content.to_s =~ /No entries found in the AFNIC Database/)
        end

        register_method :registered? do
          !available?
        end


        register_method :created_on do
          @created_on ||= if content.to_s =~ /created:\s+(.*)\n/
            d, m, y = $1.split("/")
            Time.parse("#{y}-#{m}-#{d}")
          end
        end
        
        register_method :updated_on do
          @updated_on ||= if content.to_s =~ /last-update:\s+(.*)\n/
            d, m, y = $1.split("/")
            Time.parse("#{y}-#{m}-#{d}")
          end
        end
        
        # FIXME: implement? && !support? (or anniversary?)
        register_method :expires_on do
          nil
        end

      end
      
    end
  end
end  