#
# = Ruby Whois
#
# A pure Ruby WHOIS client.
#
#
# Category::    Net
# Package::     WWW::Delicious
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
  
end

module Kernel
  def whois(string)
    Whois::Client.new.query(string)
  end
end