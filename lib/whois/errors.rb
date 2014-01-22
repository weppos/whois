#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


module Whois

  # The base error class for all <tt>Whois</tt> error classes.
  class Error < StandardError
  end

  # Raised when the connection to the WHOIS server fails.
  class ConnectionError < Error
  end


  # @!group Server

  # Generic class for server errors.
  class ServerError < Error
  end


  # Raised when the class hasn't been able to select a valid server
  # probably because definitions are outdated.
  #
  # Definition is not recognized.
  class ServerNotFound < ServerError
  end


  # Raised when we know about a specific functionality
  # but this functionality has not been implemented yet.
  # This is usually the result of a porting from a third-party library.
  #
  # Definition is recognized.
  class ServerNotImplemented < ServerError
  end

  # Raised when no WHOIS server is known for this kind of object. (\x05)
  #
  # Definition is recognized.
  class ServerNotSupported < ServerError
  end

  # Raised when unknown AS number or IP network. (\x06)
  #
  # Definition is recognized.
  class AllocationUnknown < ServerError
  end

  # @!endgroup


  # @!group Interface

  # Generic class for interfaces not supported.
  class InterfaceNotSupported < ServerError
  end

  # Raised when a server is known to not be available for this kind of object
  # or because this specific object doesn't support WHOIS. (\x03)
  class NoInterfaceError < InterfaceNotSupported
  end

  # Raised when the class has found a server but it doesn't support the
  # standard WHOIS interface via port 43. This is the case of some
  # specific domains that only provide a web–based WHOIS interface. (\x01)
  class WebInterfaceError < InterfaceNotSupported

    # @return [String] The URL of the web-based WHOIS interface.
    attr_reader :url

    # Initializes a new exception with given URL.
    #
    # @param [String] url The URL of the web-based WHOIS interface.
    def initialize(url)
      @url = url
      super("This TLD has no WHOIS server, but you can access the WHOIS database at `#{@url}'")
    end

  end

  # @!endgroup


  # @!group Parser

  # Generic class for parser errors.
  class ParserError < Error
  end

  # Raised when the library hasn't been able to load a valid parser
  # according to current settings and you're trying to access a property
  # that requires a valid parser.
  class ParserNotFound < ParserError
  end

  # Raised when you are trying to access an attribute that has not been implemented.
  class AttributeNotImplemented < ParserError
  end

  # Raised when you are trying to access an attribute that is not supported.
  class AttributeNotSupported < ParserError
  end

  # @!endgroup


  # @!group Response

  # Generic class for response errors.
  class ResponseError < Error
  end

  # Raised when attempting to access a property when the response is throttled.
  #
  # @see Whois::Record::Parser::Base#response_throttled?
  class ResponseIsThrottled < ResponseError
  end

  # Raised when attempting to access a property when the response is unavailable.
  #
  # @see Whois::Record::Parser::Base#response_unavailable?
  class ResponseIsUnavailable < ResponseError
  end

  # @!endgroup

end
