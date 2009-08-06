#
# = Ruby Whois
#
# A pure Ruby WHOIS client.
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
      
      class NotImplemented < Base
        
        def request(qstring)
          raise ServerNotImplemented, "The `#{host}' feature has not been implemented yet."
        end
        
      end
      
    end
  end
end