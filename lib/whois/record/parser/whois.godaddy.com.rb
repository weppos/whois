#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      # Parser for the whois.godaddy.com server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisGodaddyCom < Base

        property_not_supported :status

        # The server is contacted only in case of a registered domain.
        property_supported :available? do
          false
        end

        property_supported :registered? do
          !available?
        end


        # property_supported :created_on do
        #   if content_for_scanner =~ /Created on: (.+)\n/
        #     Time.parse($1)
        #   end
        # end
        #
        # property_supported :updated_on do
        #   if content_for_scanner =~ /Last Updated on: (.+)\n/
        #     Time.parse($1)
        #   end
        # end
        #
        # property_supported :expires_on do
        #   if content_for_scanner =~ /Expires on: (.+)\n/
        #     Time.parse($1)
        #   end
        # end


        property_supported :registrar do
          Record::Registrar.new(
              name:         content_for_scanner[/Registrar: (.+)\n/, 1],
              url:          "http://www.godaddy.com/"
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
          content_for_scanner.scan(/Name Server: (.+)\n/).map do |line|
            Record::Nameserver.new(name: line[0].strip)
          end
        end

      private

        def build_contact(element, type)
          Record::Contact.new(
              type:         type,
              id:           nil,
              name:         value_for_property(element, 'Name'),
              organization: value_for_property(element, 'Organization'),
              address:      value_for_property(element, 'Street'),
              city:         value_for_property(element, 'City'),
              zip:          value_for_property(element, 'Postal Code'),
              state:        value_for_property(element, 'State/Province'),
              country:      value_for_property(element, 'Country'),
              phone:        value_for_property(element, 'Phone'),
              fax:          value_for_property(element, 'Fax'),
              email:        value_for_property(element, 'Email')
          )
        end

        def value_for_property(element, property)
          matches = content_for_scanner.scan(/#{element} #{property}:\s(.+)\n/)
          value = matches.collect(&:first).join(', ')
          if value == ""
            nil
          else
            value
          end
        end

      end

    end
  end
end
