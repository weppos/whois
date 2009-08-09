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
      
      class Afilias < Base
        
        def request(qstring)
          response = ask_the_socket(qstring, "whois.afilias-grs.info", DEFAULT_WHOIS_PORT)
          if response =~ /Domain Name:/ && response =~ /Whois Server:(\S+)/
            ask_the_socket(qstring, $1, DEFAULT_WHOIS_PORT)
          else
            response
          end
        end
        
      end
      
    end
  end
end