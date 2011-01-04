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


require 'whois/answer/parser/whois.tld.ee'

module Whois
  class Answer
    class Parser

      #
      # = whois.eenet.ee parser
      #
      # Parser for the whois.eenet.ee server.
      # Alias for whois.tld.ee parser.
      #
      WhoisEenetEe = WhoisTldEe
    end
  end
end
