#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/parser/scanners/whois.registry.qa.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.registry.qa server.
      #
      # @since  2.1.0
      class WhoisRegistryQa < Base
        include Scanners::Ast

        property_not_supported :disclaimer


        property_supported :domain do
          node("Domain Name")
        end

        property_not_supported :domain_id


        property_not_supported :referral_whois

        property_not_supported :referral_url


        property_supported :status do
          Array.wrap(node("Status"))
        end

        property_supported :available? do
          !!node("status:available")
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_not_supported :updated_on

        property_not_supported :expires_on


        property_supported :registrar do
          node("Registrar ID") do |raw|
            Record::Registrar.new(
              :id           => node("Registrar ID"),
              :name         => node("Registrar Name"),
              :organization => node("Registrar Name")
            )
          end
        end


        property_supported :registrant_contacts do
          build_contact("Registrant Contact", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_not_supported :admin_contacts

        property_supported :technical_contacts do
          build_contact("Tech Contact", Whois::Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          node("Name Server") do |value|
            ipv4s = node("Name Server IP") || Array.new(value.size)
            value.zip(ipv4s).map do |name, ipv4|
              Nameserver.new(:name => name, :ipv4 => ipv4)
            end
          end
        end


        # Initializes a new {Scanners::WhoisRegistryQa} instance
        # passing the {#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::WhoisRegistryQa.new(content_for_scanner).parse
        end


      private

        def build_contact(element, type)
          node("#{element} ID") do |raw|
            Record::Contact.new(
              :type         => type,
              :id           => node("#{element} ID"),
              :name         => node("#{element} Name"),
              :email        => node("#{element} Email")
            )
          end
        end

      end

    end
  end
end
