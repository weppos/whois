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

      # Parser for the whois.aero server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisAero < BaseAfilias

        self.scanner = Scanners::BaseAfilias, {
          pattern_reserved: /^Name is restricted from registration\n/,
        }


        property_supported :status do
          if reserved?
            :reserved
          else
            Array.wrap(node("Domain Status"))
          end
        end


        property_supported :updated_on do
          node("Updated On") do |value|
            Time.parse(value)
          end
        end

        property_supported :expires_on do
          node("Expires On") do |value|
            Time.parse(value)
          end
        end

        # NEWPROPERTY
        def reserved?
          !!node("status:reserved")
        end

      end

    end
  end
end
