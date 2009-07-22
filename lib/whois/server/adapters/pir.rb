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
      
      class Pir < Base
        
        def query(qstring)
          response = ask_the_socket("FULL #{qstring}", "whois.publicinterestregistry.net", DEFAULT_WHOIS_PORT)
          if response =~ /Registrant Name:SEE SPONSORING REGISTRAR/ && 
             response =~ /Registrant Street1:Whois Server:(\S+)/
            ask_the_socket(qstring, $1, DEFAULT_WHOIS_PORT)
          else
            response
          end
        end
        
      end
      
    end
  end
end