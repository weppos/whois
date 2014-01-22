#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/base_shared3'


module Whois
  class Record
    class Parser

      # Parser for the whois.rrpproxy.net server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisRrpproxyNet < Base
        include Scanners::Scannable

        self.scanner = Scanners::BaseShared3


        property_supported :disclaimer do
          node("field:disclaimer")
        end


        property_supported :domain do
          node('DOMAIN', &:downcase)
        end

        property_not_supported :domain_id


        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!node("status:available")
        end

        property_supported :registered? do
          !available?
        end

        property_supported :registrar do
          return unless registered?
          Record::Registrar.new(
              name:         'Key-Systems',
              organization: 'Key-Systems GmbH',
              url:          'http://www.domaindiscount24.com/'
          )
        end

        property_supported :registrant_contacts do
          build_contact('owner', Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact('admin', Whois::Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact('tech', Whois::Record::Contact::TYPE_TECHNICAL)
        end

        property_supported :nameservers do
          node('nameserver') do |array|
            array.map do |name|
              Nameserver.new(name: name)
            end
          end
        end

        private

        def build_contact(element, type)
          node("#{element}-contact") do
            Record::Contact.new(
                type:         type,
                id:           node("#{element}-contact"),
                name:         [node("#{element}-fname"), node("#{element}-lname")].join(' '),
                organization: node("#{element}-organization"),
                address:      node("#{element}-street"),
                city:         node("#{element}-city"),
                zip:          node("#{element}-zip"),
                state:        nil,
                country_code: node("#{element}-country"),
                phone:        node("#{element}-phone"),
                fax:          node("#{element}-fax"),
                email:        node("#{element}-email")
            )
          end
        end

      end

    end
  end
end
