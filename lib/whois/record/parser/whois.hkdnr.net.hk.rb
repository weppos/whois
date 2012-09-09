#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/whois.hkirc.hk'


module Whois
  class Record
    class Parser

      # Parser for the <tt>whois.hkdnr.net.hk</tt> server.
      # Aliases the <tt>whois.hkirc.hk</tt> parser.
      WhoisHkdnrNetHk = WhoisHkircHk

    end
  end
end
