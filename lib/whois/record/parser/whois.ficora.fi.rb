#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/whois.fi'


module Whois
  class Record
    class Parser

      # Parser for the whois.ficora.fi server.
      #
      # It aliases the whois.fi parser.
      WhoisFicoraFi = WhoisFi

    end
  end
end
