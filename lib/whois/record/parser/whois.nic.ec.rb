#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/parser/base_cocca'


module Whois
  class Record
    class Parser

      # Parser for the whois.nic.ec server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisNicEc < BaseCocca
        property_supported :status do
          if content_for_scanner =~ /Status:\s+(.+?)\n/
            super()
          else
            registrar ? :registered : :available
            # Whois.bug!(ParserError, "Unable to parse status.")
          end
        end
      end

    end
  end
end
