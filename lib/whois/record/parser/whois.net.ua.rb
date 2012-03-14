#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/whois.ua.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.net.ua server.
      #
      # It aliases the whois.ua parser.
      WhoisNetUa = WhoisUa

    end
  end
end
