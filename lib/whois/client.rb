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


require 'socket'
require 'timeout'


module Whois

  class Client

    # The maximum time to run a whois query expressed in seconds
    DEFAULT_TIMEOUT = 5

    attr_accessor :timeout


    #
    # :call-seq:
    #   new { |client| ... } => client
    #   new(options = {}) { |client| ... } => client
    # 
    # Initializes a new Whois::Client with <tt>options</tt>.
    # 
    # If block is given, yields self.
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


    class Query # :nodoc
      # IPv6?
      # RPSL?
      # email?
      # NSIC?
      # ASP32?
      # IP?
      # domain?
      # network?
    end


    # Queries the right whois server for <tt>qstring</tt> and returns
    # a <tt>Whois::Answer</tt> instance containing the response from the server.
    #
    #   client.query("google.com")
    #   # => #<Whois::Answer>
    #
    def query(qstring)
      qstring = qstring.to_s
      Timeout::timeout(timeout) do
        @server = Server.guess(qstring)
        @server.query(qstring)
      end
    end

  end

end