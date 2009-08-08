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

    # The maximum time to run a whois query expressed in seconds
    DEFAULT_TIMEOUT = 5

    attr_accessor :timeout


    def initialize(options = {})
      self.timeout = options[:timeout] || DEFAULT_TIMEOUT
    end


    class Query # :nodoc
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
      Timeout::timeout(timeout) do
        @server = Server.guess(qstring)
        @server.query(qstring)
      end
    end
      
  end

end