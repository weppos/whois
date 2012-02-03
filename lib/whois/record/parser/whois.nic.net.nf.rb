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

      # Parser for the whois.nic.net.nf server.
      class WhoisNicNetNf < BaseCocca

        property_supported :status do
          if content_for_scanner =~ /Status:\s+(.+?)\n/
            case s = $1.downcase
            when "active"         then :registered
            when "delegated"      then :registered
            when "not registered" then :available
            when /pending delete/ then :redemption
            when /pending purge/  then :redemption
            when /not have any records for that zone/ then :invalid
            else
              Whois.bug!(ParserError, "Unknown status `#{s}'.")
            end
          else
            Whois.bug!(ParserError, "Unable to parse status.")
          end
        end


        # NEWPROPERTY
        def valid?
          cached_properties_fetch(:valid?) do
            !invalid?
          end
        end

        # NEWPROPERTY
        def invalid?
          cached_properties_fetch(:invalid?) do
            status == :invalid
          end
        end

      end

    end
  end
end
