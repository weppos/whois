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


require 'timeout'


module Whois

  class Client

    # The maximum time to run a WHOIS query, expressed in seconds.
    #
    # @return [Fixnum] Timeout value in seconds.
    DEFAULT_TIMEOUT = 10

    # @return [Fixnum, nil] The current timeout value, expressed in seconds.
    attr_accessor :timeout


    # Initializes a new <tt>Whois::Client</tt> with <tt>settings</tt>.
    #
    # If <tt>block</tt> is given, yields <tt>self</tt>.
    #
    # @param  [Hash] options Hash of options.
    # @option settings [Fixnum, nil] :timeout (DEFAULT_TIMEOUT)
    #         The script timeout, expressed in seconds.
    #
    # @yield  [self]
    #
    # @example Creating a new client
    #   client = Whois::Client.new
    #   client.query("google.com")
    #
    # @example Creating a new client with custom settings
    #   client = Whois::Client.new(:timeout => nil)
    #   client.query("google.com")
    #
    # @example Creating a new client an yielding the instance
    #   Whois::Client.new do |c|
    #     c.query("google.com")
    #   end
    #
    def initialize(settings = {}, &block)
      settings = settings.dup
      self.timeout = settings.key?(:timeout) ? settings.delete(:timeout) : DEFAULT_TIMEOUT
      yield(self) if block_given?
    end


    # Queries the right WHOIS server for <tt>qstring</tt> and returns
    # the response from the server.
    #
    # @param  [String] object The string to be sent as query parameter.
    # @return [Whois::Answer] The answer object containing the WHOIS response.
    #
    # @raise  [Timeout::Error]
    #
    # @example
    #
    #   client.query("google.com")
    #   # => #<Whois::Answer>
    #
    def query(object)
      string = object.to_s
      Timeout::timeout(timeout) do
        @server = Server.guess(string)
        @server.query(string)
      end
    end

  end

end
