#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_cocca'


module Whois
  class Record
    class Parser

      # Parser for the whois.na-nic.com.na server.
      class WhoisNaNicComNa < BaseCocca

        property_supported :status do
          if content_for_scanner =~ /Status:\s+(.+?)\n/
            case $1.downcase
            when "active"         then :registered
            when "not registered" then :available
            when "suspended"      then :inactive
            else
              Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            Whois.bug!(ParserError, "Unable to parse status.")
          end
        end

      end

    end
  end
end
