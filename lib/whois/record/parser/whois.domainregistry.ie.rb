#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/whois.domainregistry.ie.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.domainregistry.ie server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisDomainregistryIe < Base
        include Scanners::Nodable

        property_supported :disclaimer do
          node("field:disclaimer")
        end


        property_supported :domain do
          node("domain")
        end

        property_not_supported :domain_id


        property_supported :status do
          case node("status", &:downcase)
          when /^active/
            :registered
          when nil
            if node("status:pending")
              :registered
            else
              :available
            end
          else
            Whois.bug!(ParserError, "Unknown status `#{node("status")}'.")
          end
        end

        property_supported :available? do
          !!node("status:available")
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_not_supported :updated_on

        property_supported :expires_on do
          node("renewal") { |value| Time.parse(value) }
        end


        property_not_supported :registrar


        property_supported :registrant_contacts do
          node("descr") do |array|
            Record::Contact.new(
              :type         => Whois::Record::Contact::TYPE_REGISTRANT,
              :id           => nil,
              :name         => array[0]
            )
          end
        end

        property_supported :admin_contacts do
          build_contact("admin-c", Whois::Record::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contacts do
          build_contact("tech-c", Whois::Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          Array.wrap(node("nserver")).map do |line|
            name, ipv4 = line.split(/\s+/)
            Record::Nameserver.new(:name => name, :ipv4 => ipv4)
          end
        end


        # Initializes a new {Scanners::WhoisDomainregistryIe} instance
        # passing the {#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::WhoisDomainregistryIe.new(content_for_scanner).parse
        end


      private

        def build_contact(element, type)
          Array.wrap(node(element)).map do |id|
            contact = node("field:#{id}")
            Record::Contact.new(
              :type         => type,
              :id           => id,
              :name         => contact["person"]
            )
          end
        end

      end

    end
  end
end
