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

      #
      # = whois.ausregistry.net.au parser
      #
      # Parser for the whois.ausregistry.net.au server.
      # Aliases the whois.audns.net.au.
      #
      class WhoisAusregistryNetAu < WhoisAudnsNetAu
      end

    end
  end
end
