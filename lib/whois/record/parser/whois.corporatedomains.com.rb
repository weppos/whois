#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2015 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_icann_compliant'


module Whois
  class Record
    class Parser

      # Parser for the whois.markmonitor.com server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisCorporatedomainsCom < BaseIcannCompliant
        self.scanner = Scanners::BaseIcannCompliant, {
            pattern_available: /^No match for/
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
              organization: node('Sponsoring Registrar'),
              url:          node('Referral URL'),
          )
        end


      end
    end
  end
end
