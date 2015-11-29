#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2015 Simone Carletti <weppos@weppos.net>
#++


require 'whois/version'
require 'whois/errors'
require 'whois/client'
require 'whois/server'
require 'whois/record'


module Whois

  class << self

    # Queries the WHOIS server for <tt>object</tt> and returns
    # the response from the server.
    #
    # @param  [String] object The string to be sent as query parameter.
    # @return [Whois::Record] The record containing the response from the WHOIS server.
    #
    # @example
    #   Whois.lookup("google.com")
    #   # => #<Whois::Record>
    #
    #   # Equivalent to
    #   Whois::Client.new.lookup("google.com")
    #
    def lookup(object)
      Client.new.lookup(object)
    end

    alias_method :whois, :lookup


    # Echoes a deprecation warning message.
    #
    # @param  [String] message The message to display.
    # @return [void]
    #
    # @api private
    # @private
    def deprecate(message = nil, callstack = caller)
      message ||= "You are using deprecated behavior which will be removed from the next major or minor release."
      # warn("DEPRECATION WARNING: #{message} #{deprecation_caller_message(callstack)}")
      warn("DEPRECATION WARNING: #{message}")
    end

    # Appends <em>Please report issue to</em> to the message
    # and raises a new +error+ with the final message.
    #
    # @param  [Exception] error
    # @param  [String] message
    # @return [void]
    #
    # @api private
    # @private
    def bug!(error, message)
      raise error, message.dup        <<
        " Please report the issue at" <<
        " http://github.com/weppos/whois/issues"
    end

    private

    def deprecation_caller_message(callstack)
      file, line, method = extract_callstack(callstack)
      if file
        if line && method
          "(called from #{method} at #{file}:#{line})"
        else
          "(called from #{file}:#{line})"
        end
      end
    end

    def extract_callstack(callstack)
      gem_root = File.expand_path("../../../", __FILE__) + "/"
      offending_line = callstack.find { |line| !line.start_with?(gem_root) } || callstack.first
      if offending_line
        if md = offending_line.match(/^(.+?):(\d+)(?::in `(.*?)')?/)
          md.captures
        else
          offending_line
        end
      end
    end
  end

end
