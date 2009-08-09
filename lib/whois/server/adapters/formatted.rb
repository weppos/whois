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
      
      class Formatted < Base
        
        def request(qstring)
          query_the_socket(sprintf(options[:format], qstring), host)
        end
        
      end
      
    end
  end
end