#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'timeout'


module Whois

  class Client

    # The maximum time to run a WHOIS query, expressed in seconds.
    #
    # @return [Fixnum] Timeout value in seconds.
    DEFAULT_TIMEOUT = 10

    # @return [Fixnum, nil] The current timeout value, expressed in seconds.
    attr_accessor :timeout

    # @return [Hash] The current client settings.
    attr_accessor :settings


    # Initializes a new <tt>Whois::Client</tt> with <tt>settings</tt>.
    #
    # If <tt>block</tt> is given, yields <tt>self</tt>.
    #
    # @param  [Hash] settings Hash of settings to customize the client behavior.
    # @option settings [Integer, nil] :timeout (DEFAULT_TIMEOUT)
    #         The timeout for a WHOIS query, expressed in seconds.
    # @option settings [String] :bind_host (nil)
    #         Providing an IP address or hostname will bind the Socket connection
    #         to the specific local host.
    # @option settings [Fixnum] :bind_port (nil)
    #         Providing port number will bind the Socket connection
    #         to the specific local port.
    # @option settings [String, nil] :host (nil)
    #         The server host to query. Leave it blank for intelligent detection.
    # @option settings [Boolean, nil] :referral (nil)
    #         Set to +false+ to disable queries to referral WHOIS servers.
    #
    # @yield  [self]
    #
    # @example Creating a new Client
    #   client = Whois::Client.new
    #   client.lookup("google.com")
    #
    # @example Creating a new Client with custom settings
    #   client = Whois::Client.new(:timeout => nil)
    #   client.lookup("google.com")
    #
    # @example Creating a new Client an yield the instance
    #   Whois::Client.new do |c|
    #     c.lookup("google.com")
    #   end
    #
    # @example Binding the requests to a custom local IP
    #   client = Whois::Client.new(:bind_host => "127.0.0.1", :bind_port => 80)
    #   client.lookup("google.com")
    #
    def initialize(settings = {})
      settings = settings.dup

      self.timeout  = settings.key?(:timeout) ? settings.delete(:timeout) : DEFAULT_TIMEOUT
      self.settings = settings

      yield(self) if block_given?
    end


    # Lookups the right WHOIS server for <tt>object</tt>
    # and returns the response from the server.
    #
    # @param  [#to_s] object The string to be sent as lookup parameter.
    # @return [Whois::Record] The object containing the WHOIS response.
    #
    # @raise  [Timeout::Error]
    #
    # @example
    #
    #   client.lookup("google.com")
    #   # => #<Whois::Record>
    #
    def lookup(object)
      string = object.to_s.downcase
      Timeout::timeout(timeout) do
        @server = Server.guess(string)
        @server.configure(settings)
        @server.lookup(string)
      end
    end

  end

end
