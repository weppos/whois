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
      
      class Formatted < Base
        
        def query(qstring)
          ask_the_socket(sprintf(options[:format], qstring), server, options[:port] || 43)
        end
        
      end
      
    end
  end
end