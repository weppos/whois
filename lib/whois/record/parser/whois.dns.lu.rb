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

      # Parser for the whois.dns.lu server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisDnsLu < Base

        property_supported :status do
          if content_for_scanner =~ /domaintype:\s+(.+)\n/
            case $1.downcase
            when "active"
              :registered
            else
              Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /% No such domain/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /registered:\s+(.*)\n/
            # Force the parser to use the dd/mm/yyyy format.
            Time.utc(*$1.split("/").reverse)
          end
        end

        property_not_supported :updated_on

        property_not_supported :expires_on


        property_supported :registrar do
          if name = value_for_key('registrar-name')
            Record::Registrar.new(
                name:         name,
                url:          value_for_key('registrar-url'),
            )
          end
        end

        property_supported :registrant_contacts do
          build_contact('org', Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact('adm', Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact('tec', Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          values_for_key('nserver').map do |line|
            if line =~ /(.+) \[(.+)\]/
              Record::Nameserver.new(name: $1, ipv4: $2)
            else
              Record::Nameserver.new(name: line)
            end
          end
        end


        private

        def build_contact(element, type)
          if name = value_for_key('%s-name' % element)
            Record::Contact.new(
                type:         type,
                id:           nil,
                name:         name,
                address:      value_for_key('%s-address' % element),
                city:         value_for_key('%s-city' % element),
                zip:          value_for_key('%s-zipcode' % element),
                country_code: value_for_key('%s-country' % element),
                email:        value_for_key('%s-email' % element)
            )
          end
        end

        def value_for_key(key)
          values = values_for_key(key)
          if values.size > 1
            values.join(', ')
          else
            values.first
          end
        end

        def values_for_key(key)
          content_for_scanner.scan(/#{key}:\s+(.+)\n/).flatten
        end

      end
    end
  end
end