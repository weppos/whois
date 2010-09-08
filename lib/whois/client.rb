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

    # The Integer maximum time to run a whois query, expressed in seconds.
    DEFAULT_TIMEOUT = 10

    attr_accessor :timeout


    # Initializes a new <tt>Whois::Client</tt> with <tt>options</tt>.
    #
    #   new { |client| ... } => client
    #   new(options = {}) { |client| ... } => client
    #
    # ==== Parameters
    #
    # options:: Hash of options (default: {}):
    #           :timeout - The Integer script timeout, expressed in seconds (default: DEFAULT_TIMEOUT).
    #
    # If <tt>block</tt> is given, yields <tt>self</tt>.
    #
    # ==== Returns
    #
    # Whois::Client:: The client instance.
    #
    # ==== Examples
    #
    #   client = Whois::Client.new do |c|
    #     c.timeout = nil
    #   end
    #   client.query("google.com")
    #
    def initialize(options = {}, &block)
      self.timeout = options[:timeout] || DEFAULT_TIMEOUT
      yield(self) if block_given?
    end


    # Queries the right WHOIS server for <tt>qstring</tt> and returns
    # the response from the server.
    #
    # ==== Parameters
    #
    # qstring:: The String to be sent as query parameter.
    #
    # ==== Returns
    #
    # Whois::Answer:: The answer object containing the WHOIS response.
    #
    # ==== Examples
    #
    #   client.query("google.com")
    #   # => #<Whois::Answer>
    #
    def query(qstring)
      string = qstring.to_s
      Timeout::timeout(timeout) do
        @server = Server.guess(string)
        @server.query(string)
      end
    end

  end

end
