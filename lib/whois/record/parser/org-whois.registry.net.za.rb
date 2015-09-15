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

      #
      # = whois.org.za parser
      #
      # Parser for the whois.org.za server.
      #
      class OrgWhoisRegistryNetZa < ZaCentralRegistry
      end

    end
  end
end
