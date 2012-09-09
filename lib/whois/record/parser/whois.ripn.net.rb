#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/whois.tcinet.ru.rb'


module Whois
  class Record
    class Parser

      # Parser for the <tt>whois.ripn.net</tt> server.
      # Aliases the <tt>whois.tcinet.ru</tt> parser.
      WhoisRipnNet = WhoisTcinetRu

    end
  end
end
