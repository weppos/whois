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


require 'strscan'
require 'time'


module Whois
  class Response
    module Parsers
      
      #
      # = Base Response Parser
      #
      # This class is intended to be the base abstract class for all
      # server-specific parser implementations.
      #
      class Base
  
        @@allowed_methods = [
          :disclaimer, :status, :registered?, :available?,
          :created_on, :updated_on, :expires_on,
        ]
        
        def self.allowed_methods
          @@allowed_methods
        end
        
        attr_reader :response
        
        
        def initialize(response)
          @response = response
        end
        
        allowed_methods.each do |method|
          define_method(method) do
            raise NotImplementedError, "You should overwrite this method."
          end
        end
        
      end
      
    end
  end
end