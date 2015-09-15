#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2015 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_shared1'


module Whois
  class Record
    class Parser

      # Parser for the whois.registry.om server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisRegistryOm < BaseShared1

        self.scanner = Scanners::BaseShared1, {
            pattern_reserved: /^Restricted\n/
        }


        property_supported :updated_on do
          node("Last Modified") { |value| Time.parse(value) }
        end


        def reserved?
          !!node('status:reserved')
        end

      end

    end
  end
end
