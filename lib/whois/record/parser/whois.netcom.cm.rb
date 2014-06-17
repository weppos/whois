#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_cocca'


module Whois
  class Record
    class Parser

      # Parser for the whois.netcom.cm server.
      class WhoisNetcomCm < BaseCocca

        self.status_mapping.merge!({
            "suspended" => :registered
        })

      end

    end
  end
end
