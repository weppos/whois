#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'core_ext'
require 'whois/version'
require 'whois/errors'
require 'whois/client'
require 'whois/server'
require 'whois/record'


module Whois

  NAME            = "Whois"
  GEM             = "whois"
  AUTHORS         = ["Simone Carletti <weppos@weppos.net>"]


  class << self

    # Queries the WHOIS server for <tt>qstring</tt> and returns
    # the response from the server.
    #
    # @param  [String] qstring The string to be sent as query parameter.
    # @return [Whois::Record] The record containing the response from the WHOIS server.
    #
    # @example
    #   Whois.query("google.com")
    #   # => #<Whois::Record>
    #
    #   # Equivalent to
    #   Whois::Client.new.query("google.com")
    #
    def query(qstring)
      Client.new.query(qstring)
    end

    alias_method :whois, :query


    # Checks whether the object represented by <tt>qstring</tt> is available.
    #
    # Warning: this method is only available if a Whois parser exists
    # for the top level domain of <tt>qstring</tt>.
    # If no parser exists for <tt>qstring</tt>, you'll receive a
    # warning message and the method will return <tt>nil</tt>.
    # This is a technical limitation. Browse the lib/whois/record/parsers
    # folder to view all available parsers.
    #
    # @param  [String] qstring The string to be sent as query parameter.
    #         It is intended to be a domain name, otherwise this method
    #         may return unexpected responses.
    # @return [Boolean]
    #
    # @example
    #   Whois.available?("google.com")
    #   # => false
    #
    # @example
    #   Whois.available?("google-is-not-available-try-again-later.com")
    #   # => true
    #
    def available?(qstring)
      result = query(qstring).available?
      if result.nil?
        warn  "This method is not supported for this kind of object.\n" +
              "Use Whois.query('#{qstring}') instead."
      end
      result
    end

    # Checks whether the object represented by <tt>qstring</tt> is registered.
    #
    # Warning: this method is only available if a Whois parser exists
    # for the top level domain of <tt>qstring</tt>.
    # If no parser exists for <tt>qstring</tt>, you'll receive a warning message
    # and the method will return <tt>nil</tt>.
    # This is a technical limitation. Browse the lib/whois/record/parsers folder
    # to view all available parsers.
    #
    # @param  [String] qstring The string to be sent as query parameter.
    #         It is intended to be a domain name, otherwise this method
    #         may return unexpected responses.
    # @return [Boolean]
    #
    # @example
    #   Whois.registered?("google.com")
    #   # => true
    #
    # @example
    #   Whois.registered?("google-is-not-available-try-again-later.com")
    #   # => false
    #
    def registered?(qstring)
      result = query(qstring).registered?
      if result.nil?
        warn  "This method is not supported for this kind of object.\n" +
              "Use Whois.query('#{qstring}') instead."
      end
      result
    end


    # Echoes a deprecation warning message.
    #
    # @param  [String] message The message to display.
    # @return [void]
    #
    # @api internal
    # @private
    def deprecate(message = nil)
      message ||= "You are using deprecated behavior which will be removed from the next major or minor release."
      warn("DEPRECATION WARNING: #{message}")
    end

    # Appends <em>Please report issue to</em> to the message
    # and raises a new +error+ with the final message.
    #
    # @param  [Exception] error
    # @param  [String] message
    # @return [void]
    #
    # @api internal
    # @private
    def bug!(error, message)
      raise error, message.dup        <<
        " Please report the issue at" <<
        " http://github.com/weppos/whois/issues"
    end

  end

end
