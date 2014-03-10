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

      # Parser for the whois.donuts.com server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisUniregistryNet < BaseIcannCompliant
        self.scanner = Scanners::BaseIcannCompliant, {
            pattern_available: />>> Domain \".+\" is available/
        }


        property_supported :domain_id do
          node('Domain ID')
        end


        property_supported :expires_on do
          node('Registry Expiry Date') do |value|
            parse_time(value)
          end
        end


        property_supported :registrar do
          return unless node('Sponsoring Registrar')
          Record::Registrar.new(
              id:           node('Sponsoring Registrar IANA ID'),
              name:         node('Sponsoring Registrar'),
              organization: node('Sponsoring Registrar')
          )
        end


        private

        def build_contact(element, type)
          if (contact = super)
            contact.id = node("#{element} ID")
          end
          contact
        end

        def parse_time(value)
          Time.parse(value).change(usec: 0)
        end

      end

    end
  end
end
