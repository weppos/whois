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


require 'whois/answer/parser/whois.audns.net.au'


module Whois
  class Answer
    class Parser

      # Parser for the <tt>whois.ausregistry.net.au</tt> server.
      # Aliases the <tt>whois.audns.net.au</tt>.
      WhoisAusregistryNetAu = WhoisAudnsNetAu

    end
  end
end
