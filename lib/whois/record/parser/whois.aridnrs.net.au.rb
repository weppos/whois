#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/whois.aridnrs.net.au.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.aridnrs.net.au server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisAridnrsNetAu < Base
        include Scanners::Scannable

        self.scanner = Scanners::WhoisAridnrsNetAu

        property_supported :disclaimer do
          node("field:disclaimer")
        end

        property_supported :domain do
          node("Domain Name")
        end

        property_supported :domain_id do
          node("Domain ID")
        end

        property_supported :status do
          Array.wrap(node("Domain Status"))
        end

        property_supported :available? do
          !!node("status:available")
        end

        property_supported :registered? do
          !available?
        end

        property_supported :created_on do
          node("Creation Date") { |value| Time.parse(value) }
        end

        property_supported :updated_on do
          node("Updated Date") { |value| Time.parse(value) }
        end

        property_supported :expires_on do
          node("Registry Expiry Date") { |value| Time.parse(value) }
        end

        property_supported :registrar do
          if node("Sponsoring Registrar")
            Record::Registrar.new(
              :id   => node("Sponsoring Registrar IANA ID"),
              :name => node("Sponsoring Registrar")
            )
          end
        end

        property_supported :registrant_contacts do
          build_contact("Registrant", Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact("Admin", Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact("Tech", Record::Contact::TYPE_TECHNICAL)
        end

        property_supported :nameservers do
          Array.wrap(node("Name Server")).map do |name|
            Record::Nameserver.new(:name => name)
          end
        end

      private

        def build_contact(element, type)
          node("#{element} ID") do |str|
            Record::Contact.new(
              :type         => type,
              :id           => str,
              :name         => value_for_property(element, "Name"),
              :organization => value_for_property(element, "Organization"),
              :address      => value_for_property(element, "Street"),
              :city         => value_for_property(element, "City"),
              :zip          => value_for_property(element, "Postal Code"),
              :state        => value_for_property(element, "State/Province"),
              :country_code => value_for_property(element, "Country"),
              :phone        => value_for_phone_property(element, "Phone"),
              :fax          => value_for_phone_property(element, "Fax"),
              :email        => value_for_property(element, "Email")
            )
          end
        end

        def value_for_phone_property(element, property)
          [
            value_for_property(element, "#{property}"),
            value_for_property(element, "#{property} Ext")
          ].reject(&:empty?).join(' ext: ')
        end

        def value_for_property(element, property)
          Array.wrap(node("#{element} #{property}")).reject(&:empty?).join(', ')
        end

      end

    end
  end
end
