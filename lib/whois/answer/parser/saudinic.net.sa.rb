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


require 'whois/answer/parser/base'
require 'whois/answer/parser/whois.nic.net.sa'


module Whois
  class Answer
    class Parser

      #
      # = saudinic.net.sa parser
      #
      # Parser for the saudinic.net.sa server.
      # Aliases the whois.nic.net.sa parser.
      #
      class SaudinicNetSa < WhoisNicNetSa
      end

    end
  end
end
