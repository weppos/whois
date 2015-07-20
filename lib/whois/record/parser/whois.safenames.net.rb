#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_icann_compliant'


module Whois
  class Record
    class Parser

      # Parser for the whois.safenames.net server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisSafenamesNet < BaseIcannCompliant
        self.scanner = Scanners::BaseIcannCompliant, {
            pattern_available: /^No match for "[\w\.]+"\.\n/
        }

        property_supported :created_on do
          node('Created Date') do |value|
            parse_time(value)
          end
        end

        private

        def build_contact(element, type)
          node("#{element} Name") do
            address = (1..2).
              map { |i| node("#{element} Address Line #{i}") }.
              compact.join("\n").chomp

            Record::Contact.new(
              type:         type,
              id:           node("Registry #{element} ID").presence,
              name:         value_for_property(element, 'Name'),
              organization: value_for_property(element, 'Organisation'),
              address:      address,
              city:         value_for_property(element, 'City'),
              zip:          value_for_property(element, 'Postal Code'),
              state:        value_for_property(element, 'State/Province'),
              country_code: value_for_property(element, 'Country'),
              phone:        value_for_phone_property(element, 'Phone'),
              fax:          value_for_phone_property(element, 'Fax'),
              email:        value_for_property(element, 'Email')
            )
          end
        end
      end

    end
  end
end
