#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/whois.yoursrs.com'


module Whois
  class Record
    class Parser

      # Parser for the whois.yoursrs.com server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      # @author Simone Carletti
      # @author Igor Dolzhikov <bluesriverz@gmail.com>
      # @since  3.3.0
      #
      class WhoisYoursrsCom < Base
        include Scanners::Scannable

        self.scanner = Scanners::WhoisYoursrsCom


        property_supported :domain do
          node("Domain Name", &:downcase)
        end

        property_not_supported :domain_id

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
          build_contact("ADMIN", Whois::Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact("TECH", Whois::Record::Contact::TYPE_TECHNICAL)
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
                :state        => node("#{element} State"),
                :country_code => node("#{element} Country"),
                :phone        => node("#{element} Phone"),
                :fax          => node("#{element} Fax"),
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
