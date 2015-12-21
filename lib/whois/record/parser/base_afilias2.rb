#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2015 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/base_afilias'


module Whois
  class Record
    class Parser

      # Base parser for Afilias servers.
      #
      # @abstract
      class BaseAfilias2 < Base
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
          Array.wrap(node("Domain Status"))
        end

        property_supported :available? do
          !!node("status:available")
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("Creation Date") do |value|
            parse_time(value)
          end
        end

        property_supported :updated_on do
          node("Updated Date") do |value|
            parse_time(value)
          end
        end

        property_supported :expires_on do
          node("Registry Expiry Date") do |value|
            parse_time(value)
          end
        end


        property_supported :registrar do
          node("Sponsoring Registrar") do |value|
            id, name = if value =~ /(.+?) \((.+?)\)/
              [$2, $1]
            else
              [node("Sponsoring Registrar IANA ID"), node("Sponsoring Registrar")]
            end

            Record::Registrar.new({
                id:           id,
                name:         name,
            })
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
            Nameserver.new(name: name.downcase)
          end
        end


        private

        def build_contact(element, type)
          node("#{element} ID") do
            address = ["", "1", "2", "3"].
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
                :fax          => node("#{element} FAX") || node("#{element} Fax"),
                :email        => node("#{element} Email")
            )
          end
        end

      end

    end
  end
end
