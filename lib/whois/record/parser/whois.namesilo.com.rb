#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/base_icann_compliant'

module Whois
  class Record
    class Parser

      # Parser for the whois.namesilo.com server.
      class WhoisNamesiloCom < Base

        include Scanners::Scannable

        self.scanner = Scanners::BaseIcannCompliant


        property_supported :domain do
          node('domain:name', &:downcase)
        end

        property_supported :domain_id do
          node('Registry Domain ID')
        end


        property_supported :status do
          status = Array.wrap(node('Domain Status'))
          if status.empty?
            if available?
              :available
            else
              :registered
            end
          end
        end

        property_supported :available? do
          !!node('status:available')
        end

        property_supported :registered? do
          !available?
        end

        property_supported :updated_on do
          node('Updated Date') do |value|
            Time.parse(value)
          end
        end
        property_supported :created_on do
          node('Created On') do |value|
            Time.parse(value)
          end
        end

        property_supported :expires_on do
          node('Expiration Date') do |value|
            Time.parse(value)
          end
        end

        property_not_supported :registrar
      
        property_supported :registrant_contacts do
          build_contact2('Registrant', Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact2('Admin', Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact2('Tech', Record::Contact::TYPE_TECHNICAL)
        end

        property_supported :nameservers do
          Array.wrap(node('Name Server') || node('Name Servers')).reject(&:empty?).map do |name|
            Nameserver.new(:name => name.downcase)
          end
        end

      private

        def build_contact2(element, type)
          node("#{element} Street1") do
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
      end
    end
  end
end