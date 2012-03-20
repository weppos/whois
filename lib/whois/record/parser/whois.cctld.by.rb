#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++

require 'whois/record/parser/base'
require 'whois/record/parser/scanners/whois.cctld.by'

module Whois
  class Record
    class Parser

      #
      # = whois.cctld.by parser
      #
      # Parser for the whois.cctld.by server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      # @author Aliaksei Kliuchnikau <aliaksei.kliuchnikau@gmail.com>
      class WhoisCctldBy < Base
        include Scanners::Ast

        # Initializes a new {Scanners::WhoisCctldBy} instance
        # passing the {#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::WhoisCctldBy.new(content_for_scanner).parse
        end

        property_supported :available? do
          !!node("status:available")
        end

        property_supported :registered? do
          !available?
        end

        property_supported :domain do
          node("Domain Name", &:downcase)
        end

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        #property_not_supported :created_on
        #
        #property_not_supported :updated_on
        #
        #property_not_supported :expires_on

        #property_not_supported :registrar
        #
        #property_not_supported :nameservers

        property_not_supported :disclaimer

        property_not_supported :referral_whois

        property_not_supported :referral_url

        property_not_supported :domain_id

        property_not_supported :registrant_contacts

        property_not_supported :admin_contacts

        property_not_supported :technical_contacts
      end
    end
  end
end