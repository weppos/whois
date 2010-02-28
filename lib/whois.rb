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

  NAME            = 'Whois'
  GEM             = 'whois'
  AUTHORS         = ['Simone Carletti <weppos@weppos.net>']


  # Queries the right whois server for <tt>qstring</tt> and returns
  # a <tt>Whois::Answer</tt> instance containing the response from the server.
  #
  #   Whois.query("google.com")
  #   # => #<Whois::Answer>
  #
  # This is equivalent to
  #
  #   Whois::Client.new.query("google.com")
  #   # => #<Whois::Answer>
  #
  def self.whois(qstring)
    query(qstring)
  end

  # Returns <tt>true</tt> whether <tt>qstring</tt> is available.
  # <tt>qstring</tt> is intended to be a domain name,
  # otherwise this method may return unexpected responses.
  #
  #   Whois.available?("google.com")
  #   # => false
  #   
  #   Whois.available?("google-is-not-available-try-again-later.com")
  #   # => true
  #
  # Warning: this method is only available if a Whois parser exists
  # for <tt>qstring</tt> top level domain. Otherwise you'll get a warning message
  # and the method will return <tt>nil</tt>.
  # This is a technical limitation. Browse the lib/whois/answer/parsers folder
  # to view all available parsers.
  #
  def self.available?(qstring)
    query(qstring).available?
  rescue ParserNotFound => e
    $stderr.puts  "This method is not supported for this kind of object.\n" +
                  "Use Whois.query('#{qstring}') instead."
    nil
  end

  # Returns <tt>true</tt> whether <tt>qstring</tt> is registered.
  # <tt>qstring</tt> is intended to be a domain name,
  # otherwise this method may return unexpected responses.
  #
  #   Whois.registered?("google.com")
  #   # => true
  #   
  #   Whois.registered?("google-is-not-available-try-again-later.com")
  #   # => false
  #
  # Warning: this method is only available if a Whois parser exists
  # for <tt>qstring</tt> top level domain. Otherwise you'll get a warning message
  # and the method will return <tt>nil</tt>.
  # This is a technical limitation. Browse the lib/whois/answer/parsers folder
  # to view all available parsers.
  #
  def self.registered?(qstring)
    query(qstring).registered?
  rescue ParserNotFound => e
    $stderr.puts  "This method is not supported for this kind of object.\n" +
                  "Use Whois.query('#{qstring}') instead."
    nil
  end


  # See Whois#whois.
  def self.query(qstring)
    Client.new.query(qstring)
  end


  def self.deprecate(message = nil)
    message ||= "You are using deprecated behavior which will be removed from the next major or minor release."
    $stderr.puts("DEPRECATION WARNING: #{message}")
  end

end