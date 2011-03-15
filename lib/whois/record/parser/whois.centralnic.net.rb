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


require 'whois/record/parser/whois.centralnic.com'


module Whois
  class Record
    class Parser

      # Parser for the <tt>whois.centralnic.net</tt> server.
      # Aliases the <tt>whois.centralnic.com</tt> parser.
      class WhoisCentralnicNet < WhoisCentralnicCom
      end

    end
  end
end
