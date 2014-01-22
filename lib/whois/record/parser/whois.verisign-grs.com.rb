#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_verisign'


module Whois
  class Record
    class Parser

      # Parser for the whois.verisign-grs.com server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisVerisignGrsCom < BaseVerisign

        property_supported :registrar do
          node("Registrar") do |value|
            Whois::Record::Registrar.new(
                id:           last_useful_item(node("Sponsoring Registrar IANA ID")),
                name:         last_useful_item(value),
                url:          referral_url
            )
          end
        end

        # Checks whether this response contains a message
        # that can be reconducted to a "WHOIS Server Unavailable" status.
        #
        # @return [Boolean]
        def response_unavailable?
          !!node("response:unavailable")
        end

      end

    end
  end
end
