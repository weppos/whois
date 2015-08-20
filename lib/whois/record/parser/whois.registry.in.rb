#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2015 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_afilias'


module Whois
  class Record
    class Parser

      # Parser for the whois.registry.in server.
      class WhoisRegistryIn < BaseAfilias

        self.scanner = Scanners::BaseAfilias, {
            # Disclaimer starts with "Access to" in .in servers
            pattern_disclaimer: /^Access to/
        }

      end

    end
  end
end
