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

      # Parser for the whois.nic.gs server.
      class WhoisNicGs < BaseCocca

        property_supported :status do
          if content_for_scanner =~ /Status:\s+(.+?)\n/
            case s = $1.downcase
            when "active"         then :registered
            when "delegated"      then :registered
            when "not registered" then :available
            when /pending delete/ then :redemption
            else
              Whois.bug!(ParserError, "Unknown status `#{s}'.")
            end
          else
            Whois.bug!(ParserError, "Unable to parse status.")
          end
        end

      end

    end
  end
end
