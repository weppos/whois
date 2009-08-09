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
      
      class None < Base
        
        def request(qstring)
          raise NoInterfaceError, "This `#{type}' has no whois server"
        end
        
      end
      
    end
  end
end