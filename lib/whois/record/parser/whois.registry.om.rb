#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/whois.registry.om.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.registry.om server.
      # 
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      # @since  2.6.0
      class WhoisRegistryOm < Base
        include Scanners::Ast

        property_not_supported :disclaimer


        property_supported :domain do
          node('Domain Name')
        end

        property_not_supported :domain_id


        property_not_supported :referral_whois

        property_not_supported :referral_url


        property_supported :status do
          case (s = node('Status'))
          when nil
            :available
          when 'ok'
            :registered
          else
            Whois.bug!(ParserError, "Unknown status `#{s}'.")
          end
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
                :name         => name
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
          node('Name Server') do |names|
            names.map do |name|
              Record::Nameserver.new(:name => name)
            end
          end
        end


        # Initializes a new {Scanners::WhoisRegistryOm} instance
        # passing the {#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::WhoisRegistryOm.new(content_for_scanner).parse
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
