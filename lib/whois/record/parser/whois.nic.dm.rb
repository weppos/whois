#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/whois.nic.dm.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.nic.dm server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      # @since  RELEASE
      class WhoisNicDm < Base
        include Scanners::Nodable

        property_supported :disclaimer do
          node("field:disclaimer")
        end


        property_supported :domain do
          node("domain name", &:downcase)
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


        property_supported :created_on do
          node("created date") { |value| Time.parse(value) }
        end

        property_supported :updated_on do
          node("updated date") { |value| Time.parse(value) }
        end

        property_supported :expires_on do
          node("expiration date") { |value| Time.parse(value) }
        end


        property_supported :registrar do
          node("registrar") do |raw|
            Record::Registrar.new(
              :id           => nil,
              :name         => node("registrar"),
              :organization => nil,
              :url          => node("url")
            )
          end
        end

        property_supported :registrant_contacts do
          build_contact("owner", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact("admin", Whois::Record::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contacts do
          build_contact("tech", Whois::Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          node("nameserver") do |array|
            array.map do |name|
              Nameserver.new(:name => name)
            end
          end
        end


        # Initializes a new {Scanners::WhoisDnsHr} instance
        # passing the {#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::WhoisNicDm.new(content_for_scanner).parse
        end


      private

        def build_contact(element, type)
          node("#{element}-contact") do |raw|
            Record::Contact.new(
                :type         => type,
                :id           => node("#{element}-contact"),
                :name         => node("#{element}-name"),
                :organization => node("#{element}-organization"),
                :address      => node("#{element}-street"),
                :city         => node("#{element}-city"),
                :zip          => node("#{element}-zip"),
                :state        => nil,
                :country_code => node("#{element}-country"),
                :phone        => nil,
                :fax          => nil,
                :email        => nil
            )
          end
        end

      end

    end
  end
end
