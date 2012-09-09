#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/part'
require 'whois/record'
require 'socket'


module Whois
  class Server
    module Adapters

      class Base

        # Default WHOIS request port.
        DEFAULT_WHOIS_PORT = 43

        # Default bind hostname.
        DEFAULT_BIND_HOST = "0.0.0.0"

        # Array of connection errors to rescue and wrap into a {Whois::ConnectionError}
        RESCUABLE_CONNECTION_ERRORS = [
          Errno::ECONNRESET,
          Errno::EHOSTUNREACH,
          Errno::ECONNREFUSED,
          SocketError,
        ]


        # @return [Symbol] The type of WHOIS server
        attr_reader :type
        # @return [String] The allocation this server is responsible for.
        attr_reader :allocation
        # @return [String, nil] The server hostname.
        attr_reader :host
        # @return [Hash] Optional adapter properties.
        attr_reader :options

        # Temporary internal response buffer.
        #
        # @api private
        # @return [Array]
        attr_reader :buffer


        # @param  [Symbol] type
        #         The type of WHOIS adapter to define.
        #         Known values are :tld, :ipv4, :ipv6.
        # @param  [String] allocation
        #         The allocation, range or hostname, this server is responsible for.
        # @param  [String, nil] host
        #         The server hostname. Use nil if unknown or not available.
        # @param  [Hash] options Optional adapter properties.
        #
        def initialize(type, allocation, host, options = {})
          @type       = type
          @allocation = allocation
          @host       = host
          @options    = options || {}
        end

        # Checks self and other for equality.
        #
        # @param  [The Whois::Server::Adapters::Base] other
        #
        # @return [Boolean] Returns true if the other is the same object,
        #         or <tt>other</tt> attributes matches this object attributes.
        #
        def ==(other)
          (
            self.equal?(other)
          ) || (
            other.is_a?(self.class) &&
            self.type == other.type &&
            self.allocation == other.allocation &&
            self.host == other.host &&
            self.options == other.options
          )
        end

        alias_method :eql?, :==


        # Merges given +settings+ into current {#options}.
        #
        # @param  [Hash] settings
        # @return [Hash] The updated options for this object.
        #
        def configure(settings)
          options.merge!(settings)
        end


        # Performs a Whois query for <tt>string</tt>
        # using the current server adapter.
        #
        # @param  [String] string The string to be sent as query parameter.
        #
        # @return [Whois::Record]
        #
        # Internally, this method calls {#request}
        # using the Template Method design pattern.
        #
        #   server.query("google.com")
        #   # => Whois::Record
        #
        def query(string)
          buffer_start do |buffer|
            request(string)
            Whois::Record.new(self, buffer)
          end
        end

        # Performs the real WHOIS request.
        #
        # This method is not implemented in {Whois::Server::Adapters::Base} class,
        # it is intended to be overwritten in the concrete subclasses.
        # This is the heart of the Template Method design pattern.
        #
        # @param  [String] string The string to be sent as query parameter.
        #
        # @raise  [NotImplementedError]
        # @return [void]
        # @abstract
        #
        def request(string)
          raise NotImplementedError
        end


      private

        # Store a record part in {#buffer}.
        #
        # @param  [String] body
        # @param  [String] host
        # @return [void]
        #
        # @api public
        #
        def buffer_append(body, host)
          @buffer << Whois::Record::Part.new(:body => body, :host => host)
        end

        # @api private
        def buffer_start
          @buffer = []
          result = yield(@buffer)
          @buffer = [] # reset
          result
        end

        # @api public
        def query_the_socket(query, host, port = nil)
          args = []
          args.push(host)
          args.push(port || options[:port] || DEFAULT_WHOIS_PORT)

          # This is a hack to prevent +TCPSocket.new+ to crash
          # when resolv-replace.rb file is required.
          #
          # +TCPSocket.new+ defaults +local_host+ and +local_port+ to nil
          # but when you require resolv-replace.rb, +local_host+
          # is resolved when you pass any local parameter and in case of nil
          # it raises the following error
          #
          #   ArgumentError: cannot interpret as DNS name: nil
          #
          if options[:bind_host] || options[:bind_port]
            args.push(options[:bind_host] || DEFAULT_BIND_HOST)
            args.push(options[:bind_port]) if options[:bind_port]
          end

          ask_the_socket(query, *args)

        rescue *RESCUABLE_CONNECTION_ERRORS => error
          raise ConnectionError, "#{error.class}: #{error.message}"
        end

        # This method handles the lowest connection
        # to the WHOIS server.
        #
        # This is for internal use only!
        #
        # @api private
        def ask_the_socket(query, *args)
          client = TCPSocket.new(*args)
          client.write("#{query}\r\n")    # I could use put(foo) and forget the \n
          client.read                     # but write/read is more symmetric than puts/read
        ensure                            # and I really want to use read instead of gets.
          client.close if client          # If != client something went wrong.
        end

      end

    end
  end
end
