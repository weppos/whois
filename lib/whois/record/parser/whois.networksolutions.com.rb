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

      # Parser for the whois.networksolutions.com server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisNetworksolutionsCom < BaseIcannCompliant
        self.scanner = Scanners::BaseIcannCompliant, {
            pattern_available: /^No match for "[\w\.]+"\.\n/
        }

        private

        def build_contact(element, type)
          if (contact = super) && !contact.state.present?
            contact.state = value_for_property(element, 'State')
          end
          contact
        end

      end

    end
  end
end
