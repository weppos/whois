#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2015 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/za_central_registry'


module Whois
  class Record
    class Parser

      # Parser for the joburg-whois.registry.net.za server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class JoburgWhoisRegistryNetZa < ZaCentralRegistry
      end

    end
  end
end
