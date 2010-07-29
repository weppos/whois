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


    #
    # :call-seq:
    #   new { |client| ... } => client
    #   new(options = {}) { |client| ... } => client
    #
    # Initializes a new <tt>Whois::Client</tt> with <tt>options</tt>.
    #
    # options - The Hash options used to refine the selection (default: {}):
    #           :timeout - The Integer script timeout, expressed in seconds (default: DEFAULT_TIMEOUT).
    #
    # If <tt>block</tt> is given, yields <tt>self</tt>.
    #
    # Examples
    #
    #   client = Whois::Client.new do |c|
    #     c.timeout = nil
    #   end
    #   client.query("google.com")
    #
    # Returns a <tt>Whois::Client</tt>.
    def initialize(options = {}, &block)
      self.timeout = options[:timeout] || DEFAULT_TIMEOUT
      yield(self) if block_given?
    end


    class Query # :nodoc:
      # IPv6?
      # RPSL?
      # email?
      # NSIC?
      # ASP32?
      # IP?
      # domain?
      # network?
    end


    # Queries the right WHOIS server for <tt>qstring</tt> and returns
    # the response from the server.
    #
    # qstring - The String to be sent as query parameter.
    #
    # Examples
    #
    #   client.query("google.com")
    #   # => #<Whois::Answer>
    #
    # Returns a <tt>Whois::Answer</tt> instance.
    def query(qstring)
      string = qstring.to_s
      Timeout::timeout(timeout) do
        @server = Server.guess(string)
        @server.query(string)
      end
    end

  end

end
