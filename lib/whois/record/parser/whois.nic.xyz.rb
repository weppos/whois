#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2015 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/whois.centralnic.com.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.nic.xyz server.
      class WhoisNicXyz < WhoisCentralnicCom
      end
    end
  end
end
