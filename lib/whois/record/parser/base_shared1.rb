#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/base_shared1'


module Whois
  class Record
    class Parser

      # Shared parser 1.
      #
      # @abstract
      class BaseShared1 < Base
        include Scanners::Scannable

        self.scanner = Scanners::BaseShared1


        property_not_supported :disclaimer


        property_supported :domain do
          node('Domain Name')
        end

        property_not_supported :domain_id


        property_supported :status do
          Array.wrap(node("Status"))
        end

        property_supported :available? do
          !!node('status:available')
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_not_supported :updated_on

        property_not_supported :expires_on


        property_supported :registrar do
          node('Registrar Name') do |name|
            Record::Registrar.new(
                :id           => node('Registrar ID'),
                :name         => node('Registrar Name'),
                :organization => node('Registrar Name')
            )
          end
        end


        property_supported :registrant_contacts do
          build_contact('Registrant', Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_not_supported :admin_contacts

        property_supported :technical_contacts do
          build_contact('Tech', Whois::Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          node('Name Server') do |value|
            ipv4s = node('Name Server IP') || Array.new(value.size)
            value.zip(ipv4s).map do |name, ipv4|
              Nameserver.new(:name => name, :ipv4 => ipv4)
            end
          end
        end


      private

        def build_contact(element, type)
          node("#{element} Contact ID") do
            Record::Contact.new(
                :type         => type,
                :id           => node("#{element} Contact ID"),
                :name         => node("#{element} Contact Name"),
                :email        => node("#{element} Contact Email")
            )
          end
        end

      end

    end
  end
end
