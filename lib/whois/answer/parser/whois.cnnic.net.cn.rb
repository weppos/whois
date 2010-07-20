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


require 'whois/answer/parser/whois.cnnic.cn'


module Whois
  class Answer
    class Parser

      #
      # = whois.cnnic.net.cn parser
      #
      # Parser for the whois.cnnic.net.cn server.
      # Aliases the whois.cnnic.cn parser.
      #
      class WhoisCnnicNetCn < WhoisCnnicCn
      end

    end
  end
end
