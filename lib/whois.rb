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


require 'core_ext'
require 'whois/version'
require 'whois/errors'
require 'whois/client'
require 'whois/server'
require 'whois/answer'


module Whois

  NAME            = "Whois"
  GEM             = "whois"
  AUTHORS         = ["Simone Carletti <weppos@weppos.net>"]


  # Queries the right WHOIS server for <tt>qstring</tt> and returns
  # the response from the server.
  #
  # ==== Parameters
  #
  # qstring:: The String to be sent as query parameter.
  #
  # ==== Returns
  #
  # Whois::Answer:: The answer containing the response from the WHOIS server.
  #
  # ==== Examples
  #
  #   Whois.query("google.com")
  #   # => #<Whois::Answer>
  #
  # This is equivalent to
  #
  #   Whois::Client.new.query("google.com")
  #   # => #<Whois::Answer>
  #
  def self.query(qstring)
    Client.new.query(qstring)
  end

  # Checks whether the object represented by <tt>qstring</tt> is available.
  #
  # Warning: this method is only available if a Whois parser exists
  # for the top level domain of <tt>qstring</tt>.
  # If no parser exists for <tt>qstring</tt>, you'll receive a 
  # warning message and the method will return <tt>nil</tt>.
  # This is a technical limitation. Browse the lib/whois/answer/parsers
  # folder to view all available parsers.
  #
  # ==== Parameters
  #
  # qstring:: The String to be sent as query parameter.
  #           It is intended to be a domain name, otherwise this method
  #           may return unexpected responses.
  #
  # ==== Returns
  #
  # Boolean
  #
  # ==== Examples
  #
  #   Whois.available?("google.com")
  #   # => false
  #   
  #   Whois.available?("google-is-not-available-try-again-later.com")
  #   # => true
  #
  def self.available?(qstring)
    query(qstring).available?
  rescue ParserNotFound => e
    warn  "This method is not supported for this kind of object.\n" +
          "Use Whois.query('#{qstring}') instead."
    nil
  end

  # Checks whether the object represented by <tt>qstring</tt> is registered.
  #
  # Warning: this method is only available if a Whois parser exists
  # for the top level domain of <tt>qstring</tt>.
  # If no parser exists for <tt>qstring</tt>, you'll receive a warning message
  # and the method will return <tt>nil</tt>.
  # This is a technical limitation. Browse the lib/whois/answer/parsers folder
  # to view all available parsers.
  #
  # ==== Parameters
  #
  # qstring:: The String to be sent as query parameter.
  #           It is intended to be a domain name, otherwise this method
  #           may return unexpected responses.
  #
  # ==== Returns
  #
  # Boolean
  #
  # ==== Examples
  #
  #   Whois.registered?("google.com")
  #   # => true
  #   
  #   Whois.registered?("google-is-not-available-try-again-later.com")
  #   # => false
  #
  def self.registered?(qstring)
    query(qstring).registered?
  rescue ParserNotFound => e
    warn  "This method is not supported for this kind of object.\n" +
          "Use Whois.query('#{qstring}') instead."
    nil
  end


  # See <tt>Whois#query</tt>.
  def self.whois(qstring)
    query(qstring)
  end


  def self.deprecate(message = nil) # :nodoc:
    message ||= "You are using deprecated behavior which will be removed from the next major or minor release."
    warn("DEPRECATION WARNING: #{message}")
  end

  def self.bug!(error, message) # :nodoc:
    raise error, message.dup        <<
      " Please report the issue at" <<
      " http://github.com/weppos/whois/issues"
  end

end
