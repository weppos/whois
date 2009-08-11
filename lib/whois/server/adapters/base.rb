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
      
      class Base

        DEFAULT_WHOIS_PORT = 43

        attr_reader :type
        attr_reader :allocation
        attr_reader :host
        attr_reader :options

        
        def initialize(type, allocation, host, options = {})
          @type       = type
          @allocation = allocation
          @host       = host
          @options    = options || {}
        end
        
        def query(qstring)
          response = request(qstring)
          Response.new(response, self)
        end

        def request(qstring)
          raise NotImplementedError
        end

        
        protected

          def query_the_socket(qstring, host, port = nil)
            ask_the_socket(qstring, host, port || options[:port] || DEFAULT_WHOIS_PORT)
          end

        private

          def ask_the_socket(qstring, host, port)
            client = TCPSocket.open(host, port)
            client.write("#{qstring}\r\n")  # I could use put(foo) and forget the \n
            client.read                     # but write/read is more symmetric than puts/read
          ensure                            # and I really want to use read instead of gets.
            client.close if client          # If != client something went wrong.
          end
        
      end
      
    end
  end
end