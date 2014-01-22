#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'socket'
require 'whois/errors'


module Whois
  class Server

    # The SocketHandler is the default query handler provided with the
    # Whois library. It performs the WHOIS query using a synchronous
    # socket connection.
    class SocketHandler

      # Array of connection errors to rescue
      # and wrap into a {Whois::ConnectionError}
      RESCUABLE_CONNECTION_ERRORS = [
          SystemCallError,
          SocketError,
      ]

      # Performs the Socket request.
      #
      # @todo *args might probably be a Hash.
      #
      # @param  [String] query
      # @param  [Array] args
      # @return [String]
      #
      def call(query, *args)
        execute(query, *args)
      rescue *RESCUABLE_CONNECTION_ERRORS => error
        raise ConnectionError, "#{error.class}: #{error.message}"
      end

      # Executes the low-level Socket connection.
      #
      # It opens the socket passing given +args+,
      # sends the +query+ and reads the response.
      #
      # @param  [String] query
      # @param  [Array] args
      # @return [String]
      #
      # @api private
      #
      def execute(query, *args)
        client = TCPSocket.new(*args)
        client.write("#{query}\r\n")    # I could use put(foo) and forget the \n
        client.read                     # but write/read is more symmetric than puts/read
      ensure                            # and I really want to use read instead of gets.
        client.close if client          # If != client something went wrong.
      end
    end

  end
end
