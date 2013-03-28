#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/whois.registry.net.za'


module Whois
  class Record
    class Parser

      # Parser for the whois.registry.za.net server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisRegistryNetZa < Base
        include Scanners::Nodable

        property_supported :disclaimer do
          node("node:disclaimer")
        end


        property_supported :domain do
          node("node:domain")
        end

        property_not_supported :domain_id


        property_supported :status do
          node("node:status") do |string|
            string.split(", ")
          end
        end

        property_supported :available? do
          node("status:available") ? true : false
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("node:dates") do |array|
            array[0] =~ /Registration Date:\s*(\d{4}-\d{2}-\d{2})/
            parse_date($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          node("node:dates") do |array|
            array[1] =~ /Renewal Date:\s*(\d{4}-\d{2}-\d{2})/
            parse_date($1)
          end
        end


        property_supported :registrar do
          node("node:registrar") do |string|
            string =~ /(.+) \[ ID = (.+) \]/
            Whois::Record::Registrar.new(:name => $1.strip, :id => $2.strip)
          end
        end

        property_supported :registrant_contacts do
          node("node:registrant_details") do
            build_registrant_contacts
          end
        end

        property_not_supported :admin_contacts

        property_not_supported :technical_contacts


        property_supported :nameservers do
          node("node:nameservers") do |array|
            Array.wrap(array).map do |nameserver|
              Record::Nameserver.new(:name => nameserver)
            end
          end
        end


        def parse
          Scanners::WhoisRegistryNetZa.new(content_for_scanner).parse
        end


        private

        def build_registrant_contacts
          Whois::Record::Contact.new(
            { type: Whois::Record::Contact::TYPE_REGISTRANT}.merge(registrant_details).merge(registrant_address_details)
          )
        end

        def registrant_details
          lines   = node("node:registrant_details")
          details = { name: lines.shift }
          [:email, :phone, :fax].each do |contact_method|
            details[contact_method] = lines.shift.split(":", 2)[1].strip
          end
          details
        end

        def registrant_address_details
          { address: Array.wrap(node("node:registrant_address")).join("\n") }
        end

        def parse_date(date_string)
          Time.parse(date_string) if date_string
        end
      end

    end
  end
end
