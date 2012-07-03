#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_whoisd'
require 'whois/record/scanners/whoisd.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.tld.ee server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      # 
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisTldEe < BaseWhoisd

        property_supported :admin_contacts do
          node('admin-c') do |value|
            build_contact(value, Record::Contact::TYPE_ADMIN)
          end
        end

        property_supported :registrant_contacts do
          node('registrant') do |value|
            build_contact(value, Record::Contact::TYPE_REGISTRANT)
          end
        end

        property_not_supported :technical_contacts

      private

        def build_contact(element, type)
          node(element) do |hash|
            Record::Contact.new(
                :type           => type,
                :id             => element,
                :name           => hash['name'],
                :organization   => hash['org'],
                :created_on     => Time.parse(hash['created'])
            )
          end
        end

      end
    end
  end
end
