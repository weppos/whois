#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
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

        property_supported :status do
          Array.wrap(node("Domain Status"))
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

      end

    end
  end
end
