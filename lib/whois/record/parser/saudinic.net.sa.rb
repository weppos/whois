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


require 'whois/record/parser/whois.nic.net.sa'


module Whois
  class Record
    class Parser

      # Parser for the <tt>saudinic.net.sa</tt> server.
      # Aliases the <tt>whois.nic.net.sa</tt> parser.
      SaudinicNetSa = WhoisNicNetSa

    end
  end
end
