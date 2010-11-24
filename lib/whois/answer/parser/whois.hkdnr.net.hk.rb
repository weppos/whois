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


require 'whois/answer/parser/whois.hkirc.hk'


module Whois
  class Answer
    class Parser

      # Parser for the <tt>whois.hkdnr.net.hk</tt> server.
      # Aliases the <tt>whois.hkirc.hk</tt> parser.
      WhoisHkdnrNetHk = WhoisHkircHk

    end
  end
end
