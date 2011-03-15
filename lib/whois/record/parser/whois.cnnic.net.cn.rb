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


require 'whois/record/parser/whois.cnnic.cn'


module Whois
  class Record
    class Parser

      # Parser for the <tt>whois.cnnic.net.cn</tt> server.
      # Aliases the <tt>whois.cnnic.cn</tt> parser.
      WhoisCnnicNetCn = WhoisCnnicCn

    end
  end
end
