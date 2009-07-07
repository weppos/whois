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
      
      class Afilias < Base
        
        def query(qstring)
          response = ask_the_socket(qstring, "whois.afilias-grs.info")
          if response =~ /Domain Name:/ && response =~ /Whois Server:(\S+)/
            ask_the_socket(qstring, $1)
          else
            response
          end
        end
        
      end
      
    end
  end
end