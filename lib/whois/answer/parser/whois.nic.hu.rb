#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
#
# Category::    Net
# Package::     Whois
# Author::      Gábor Vészi <veszig@done.hu>, Simone Carletti <weppos@weppos.net>
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
      # = whois.nic.hu parser
      #
      # Parser for the whois.nic.hu server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicHu < Base

        register_method :status do
          last_line = content.to_s.strip.split(/\n/).compact.last
          if last_line =~ /\ANincs tal.lat \/ No match\Z/
            :available
          elsif last_line =~ /\ARegisztr.ci. folyamatban \/ Registration in progress\Z/
            :in_progress
          else
            :registered
          end
        end
        
        register_method :available? do
          @available ||= status == :available
        end
        
        register_method :registered? do
          @registered ||= status == :registered
        end
        
        register_method :created_on do
          @created_on ||= if content.to_s =~ /registered:\s+(.*?)[\r\n]+/
            Time.parse($1)
          end
        end
        
        register_method :updated_on do
          @updated_on ||= if content.to_s =~ /changed:\s+(.*?)[\r\n]+/
            Time.parse($1)
          end
        end
        
      end
      
    end
  end
end