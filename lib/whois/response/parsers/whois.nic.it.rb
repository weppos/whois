#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client.
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


require 'whois/response/parsers/base'


module Whois
  class Response
    module Parsers
      
      class WhoisNicIt < Base
        
        def status
          response.i_m_feeling_lucky(/^Status:\s+(.+)$/) { |m| m.downcase.to_sym }
        end
        
        def available?
          response.match?(/^Status:\s+AVAILABLE$/)
        end
        
        def registered?
          !available?
        end
        
        
        def created_on
          return unless registered?
          response.i_m_feeling_lucky(/^Created:\s+(.+)$/) { |m| Time.parse(m) }
        end
        
        def updated_on
          return unless registered?
          response.i_m_feeling_lucky(/^Last Update:\s+(.+)$/) { |m| Time.parse(m) }
        end
        
        def expires_on
          return unless registered?
          response.i_m_feeling_lucky(/^Expire Date:\s+(.+)$/) { |m| Time.parse(m) }
        end
        
      end
      
    end
  end
end