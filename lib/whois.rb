#
# = Ruby Whois
#
# A pure Ruby WHOIS client.
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


module Whois

  NAME            = 'Whois'
  GEM             = 'whois'
  AUTHORS         = ['Simone Carletti <weppos@weppos.net>']
  
  def self.whois(qstring)
    Whois::Client.new.query(qstring)
  end
end