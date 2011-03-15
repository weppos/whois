#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2011 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/whois.kr'


module Whois
  class Record
    class Parser

      # Parser for the <tt>whois.nic.or.kr</tt> server.
      # Aliases the <tt>whois.kr</tt>.
      WhoisNicOrKr = WhoisKr

    end
  end
end
