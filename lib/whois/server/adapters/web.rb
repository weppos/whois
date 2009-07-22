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
      
      class Web < Base
        
        def request(qstring)
          raise WebInterfaceError,  "This TLD has no whois server, " +
                                    "but you can access the whois database at `#{options[:web]}'"
        end
        
      end
      
    end
  end
end