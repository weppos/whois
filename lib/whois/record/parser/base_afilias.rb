#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/base_afilias'


module Whois
  class Record
    class Parser

      # Base parser for Afilias servers.
      #
      # @abstract
      class BaseAfilias < Base
        include Scanners::Scannable

        self.scanner = Scanners::BaseAfilias


        property_supported :disclaimer do
          node("field:disclaimer")
        end


        property_supported :domain do
          node("Domain Name", &:downcase)
        end

        property_supported :domain_id do
          node("Domain ID")
        end


        property_supported :status do
          Array.wrap(node("Status"))
        end

        property_supported :available? do
          !!node("status:available")
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("Created On") do |value|
            Time.parse(value)
          end
        end

        property_supported :updated_on do
          node("Last Updated On") do |value|
            Time.parse(value)
          end
        end

        property_supported :expires_on do
          node("Expiration Date") do |value|
            Time.parse(value)
          end
        end


        property_supported :registrar do
          node("Sponsoring Registrar") do |value|
            parts = decompose_registrar(value) ||
                Whois.bug!(ParserError, "Unknown registrar format `#{value}'")

            Record::Registrar.new(
                id:           parts[0],
                name:         parts[1]
            )
          end
        end

        property_supported :registrant_contacts do
          build_contact("Registrant", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact("Admin", Whois::Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact("Tech", Whois::Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          Array.wrap(node("Name Server")).reject(&:empty?).map do |name|
            Nameserver.new(:name => name.downcase)
          end
        end


        private

        def build_contact(element, type)
          node("#{element} ID") do
            address = (1..3).
                map { |i| node("#{element} Street#{i}") }.
                delete_if { |i| i.nil? || i.empty? }.
                join("\n")

            Record::Contact.new(
                :type         => type,
                :id           => node("#{element} ID"),
                :name         => node("#{element} Name"),
                :organization => node("#{element} Organization"),
                :address      => address,
                :city         => node("#{element} City"),
                :zip          => node("#{element} Postal Code"),
                :state        => node("#{element} State/Province"),
                :country_code => node("#{element} Country"),
                :phone        => node("#{element} Phone"),
                :fax          => node("#{element} FAX"),
                :email        => node("#{element} Email")
            )
          end
        end

        def decompose_registrar(value)
          if value =~ /(.+?) \((.+?)\)/
            [$2, $1]
          end
        end

      end

    end
  end
end
