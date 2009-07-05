#
# = Ruby Whois
#
# A pure Ruby WHOIS client.
#
#
# Category::    Net
# Package::     WWW::Delicious
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
    
    
    def query(string)
      server = Server.whichwhois(string)
      ask_the_socket(string, server)
    end
    
    private
      
      def ask_the_socket(query, server, port = 43)
        client = TCPSocket.open(server, port)
        client.write("#{query}\n")    # I could use put(foo) and forget the \n
        client.read                   # but write/read sounds better than puts/read
      ensure                          # and I really want to use read instead of gets.
        client.close if client        # If != client something went wrong.
      end
      
  end

end