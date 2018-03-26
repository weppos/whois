#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2018 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/part'


module Whois

  class Record


    # @return [Whois::Server] The server that originated this record.
    attr_reader :server

    # @return [Array<Whois::Record::Part>] The parts that compose this record.
    attr_reader :parts


    # Initializes a new instance with given +server+ and +parts+.
    #
    # @param  [Whois::Server] server
    # @param  [Array<Whois::Record::Part>] parts
    #
    def initialize(server, parts)
      @parts  = parts
      @server = server
    end


    # Returns a String representation of this record.
    #
    # @return [String] The record content.
    #
    def to_s
      content.to_s
    end

    # Returns a human-readable representation of this record.
    #
    # @return [String] The result of {#inspect} on content.
    #
    def inspect
      content.inspect
    end

    # Returns true if the <tt>object</tt> is the same object,
    # or is a string and has the same content.
    #
    # @param  [Whois::Record] other The record to compare.
    # @return [Boolean]
    #
    def ==(other)
      if equal?(other)
        true
      elsif other.is_a?(self.class)
        to_s == other.to_s
      else
        false
      end
    end

    alias_method :eql?, :==


    # Invokes {#match} on record {#content}
    # and returns the match as <tt>MatchData</tt> or <tt>nil</tt>.
    #
    # @param  [Regexp, String] pattern The regex pattern to match.
    # @return [MatchData] If pattern matches #content
    # @return [nil] If pattern doesn't match #content
    #
    # @see String#match
    #
    def match(pattern)
      content.match(pattern)
    end

    # Invokes {#match} and returns <tt>true</tt> if <tt>pattern</tt>
    # matches {#content}, <tt>false</tt> otherwise.
    #
    # @param  [Regexp, String] pattern The regex pattern to match.
    # @return [Boolean]
    #
    # @see #match
    #
    def match?(pattern)
      !content.match(pattern).nil?
    end

    # Joins and returns all record parts into a single string
    # and separates each response with a newline character.
    #
    # @example Record with one part
    #   record = Whois::Record.new([Whois::Record::Part.new(:body => "First record.")])
    #   record.content
    #   # => "First record."
    #
    # @example Record with multiple parts
    #   record = Whois::Record.new([Whois::Record::Part.new(:body => "First record."), Whois::Record::Part.new(:body => "Second record.")])
    #   record.content
    #   # => "First record.\nSecond record."
    #
    # @return [String] The content of this record.
    #
    def content
      @content ||= parts.map(&:body).join("\n")
    end

  end

end
