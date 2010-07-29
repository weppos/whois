#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
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


require 'whois/answer/part'
require 'whois/answer'
require 'socket'


module Whois
  class Server
    module Adapters

      class Base

        # Default Whois request port.
        DEFAULT_WHOIS_PORT = 43

        attr_reader :type
        attr_reader :allocation
        attr_reader :host
        attr_reader :options
        attr_reader :buffer

        def initialize(type, allocation, host, options = {})
          @type       = type
          @allocation = allocation
          @host       = host
          @options    = options || {}
        end

        # Checks self and other for equality.
        #
        # other - The Whois::Server::Adapter::* to check.
        #
        # Returns true if the <tt>other</tt> is the same object,
        # or <tt>other</tt> attributes matches this object attributes.
        def ==(other)
          (self.equal?(other)) ||
          (
            self.type == other.type &&
            self.allocation == other.allocation &&
            self.host == other.host &&
            self.options == other.options
          )
        end

        # Delegates to #==.
        #
        # other - The Whois::Server::Adapter::* to check.
        #
        # Returns true or false.
        def eql?(other)
          self == other
        end


        # Performs a Whois query for <tt>qstring</tt> 
        # using current server adapter and returns a <tt>Whois::Response</tt>
        # instance with the result of the request.
        #
        # qstring - The String to be sent as query parameter.
        #
        # Internally, this method calls #request
        # using the Template Method design pattern.
        #
        #   server.query("google.com")
        #   # => Whois::Answer
        #
        # Returns a Whois::Answer.
        def query(qstring)
          with_buffer do |buffer|
            request(qstring)
            Answer.new(self, buffer)
          end
        end

        # Performs the real WHOIS request.
        #
        # qstring - The String to be sent as query parameter.
        #
        # This method is not implemented in Whois::Adapter::Base class,
        # it is intended to be overwritten in the concrete subclasses.
        # This is the heart of the Template Method design pattern.
        #
        # Raises NotImplementedError.
        # Returns nothing.
        def request(qstring)
          raise NotImplementedError
        end


        protected

          def with_buffer(&block)
            @buffer = []
            result = yield(@buffer)
            @buffer = []
            result
          end

          # Store an answer part in <tt>@buffer</tt>.
          def append_to_buffer(response, host)
            @buffer << ::Whois::Answer::Part.new(response, host)
          end

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
