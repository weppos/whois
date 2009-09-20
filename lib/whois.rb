#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client.
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


require 'whois/version'
require 'whois/errors'
require 'whois/client'
require 'whois/server'
require 'whois/answer'
require 'whois/whois'


module Whois

  NAME            = 'Whois'
  GEM             = 'whois'
  AUTHORS         = ['Simone Carletti <weppos@weppos.net>']


  def self.query(qstring)
    Client.new.query(qstring)
  end

  def self.whois(qstring)
    query(qstring)
  end

  def self.available?(qstring)
    query(qstring).available?
  rescue ParserNotFound => e
    $stderr.puts  "This method is not available for this kind of object.\n" +
                  "Use Whois.query('#{qstring}') instead."
    nil
  end

  def self.registered?(qstring)
    query(qstring).registered?
  rescue ParserNotFound => e
    $stderr.puts  "This method is not available for this kind of object.\n" +
                  "Use Whois.query('#{qstring}') instead."
    nil
  end
  
end