#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/whois.audns.net.au'


module Whois
  class Record
    class Parser

      # Parser for the <tt>whois.ausregistry.net.au</tt> server.
      # Aliases the <tt>whois.audns.net.au</tt>.
      WhoisAusregistryNetAu = WhoisAudnsNetAu

    end
  end
end
