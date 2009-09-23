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


module Whois
  class Server
    module Adapters
      
      class Standard < Base
        
        def request(qstring)
          response = query_the_socket(qstring, host)
          append_to_buffer response, host
        end
        
      end
      
    end
  end
end