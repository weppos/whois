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


require 'socket'
require 'timeout'


module Whois

  class Client

    class Query
      # IPv6?
      # RPSL?
      # email?
      # NSIC?
      # ASP32?
      # IP?
      # domain?
      # network?
    end
    
    
    def query(qstring)
      @server = Server.guess(qstring)
      @server.query(qstring)
    end
      
  end

end