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
      
      class Base
        
        attr_reader :extension
        attr_reader :server
        attr_reader :options
        
        def initialize(extension, server, options = {})
          @extension  = extension
          @server     = server
          @options    = options || {}
        end
        
        def query(qstring)
          raise NotImplementedError
        end
        
        
        private
          
          def ask_the_socket(qstring, server, port = 43)
            client = TCPSocket.open(server, port)
            client.write("#{qstring}\r\n")  # I could use put(foo) and forget the \n
            client.read                   # but write/read sounds better than puts/read
          ensure                          # and I really want to use read instead of gets.
            client.close if client        # If != client something went wrong.
          end
        
      end
      
    end
  end
end