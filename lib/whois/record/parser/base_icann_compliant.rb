#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/base_icann_compliant'


module Whois
  class Record
    class Parser

      # Base parser for ICANN Compliant servers.
      #
      # @see http://www.icann.org/en/resources/registrars/raa/approved-with-specs-27jun13-en.htm#whois
      #
      # @author Simone Carletti
      # @author Igor Dolzhikov <bluesriverz@gmail.com>
      #
      class BaseIcannCompliant < Base
        include Scanners::Scannable

        self.scanner = Scanners::BaseIcannCompliant


        property_supported :domain do
          node('Domain Name', &:downcase)
        end

        property_supported :domain_id do
          node('Registry Domain ID')
        end


        property_supported :status do
          # status = Array.wrap(node('Domain Status'))
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!node('status:available')
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node('Creation Date') do |value|
            Time.parse(value)
          end
        end

        property_supported :updated_on do
          node('Updated Date') do |value|
            Time.parse(value)
          end
        end

        property_supported :expires_on do
          node('Registrar Registration Expiration Date') do |value|
            Time.parse(value)
          end
        end


        property_supported :registrar do
          return unless node('Registrar')
          Record::Registrar.new(
              id:           node('Registrar IANA ID'),
              name:         node('Registrar'),
              organization: node('Registrar'),
              url:          node('Registrar URL'),
          )
        end


        property_supported :registrant_contacts do
          build_contact('Registrant', Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact('Admin', Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact('Tech', Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          Array.wrap(node('Name Server') || node('Name Servers')).reject(&:empty?).map do |name|
            Nameserver.new(name: name.downcase)
          end
        end


        private

        def build_contact(element, type)
          node("#{element} Name") do
            Record::Contact.new(
                type:         type,
                id:           node("Registry #{element} ID"),
                name:         value_for_property(element, 'Name'),
                organization: value_for_property(element, 'Organization'),
                address:      value_for_property(element, 'Street'),
                city:         value_for_property(element, 'City'),
                zip:          value_for_property(element, 'Postal Code'),
                state:        value_for_property(element, 'State/Province'),
                country_code: value_for_property(element, 'Country'),
                phone:        value_for_phone_property(element, 'Phone'),
                fax:          value_for_phone_property(element, 'Fax'),
                email:        value_for_property(element, 'Email')
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
