#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/whois.kr'


module Whois
  class Record
    class Parser

      # Parser for the whois.nic.or.kr server.
      #
      # It aliases the whois.kr parser.
      WhoisNicOrKr = WhoisKr

    end
  end
end
