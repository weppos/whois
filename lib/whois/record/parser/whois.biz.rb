#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/parser/scanners/whois.biz.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.biz server.
      class WhoisBiz < Base
        include Scanners::Ast

        # Actually the :disclaimer is supported,
        # but extracting it with the current scanner
        # would require too much effort.
        # property_supported :disclaimer


        property_supported :domain do
          node("Domain Name", &:downcase)
        end

        property_supported :domain_id do
          node("Domain ID")
        end


        property_not_supported :referral_whois

        property_not_supported :referral_url


        property_supported :status do
          node("Domain Status")
        end

        property_supported :available? do
          !!node("status:available")
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("Domain Registration Date") { |value| Time.parse(value) }
        end

        property_supported :updated_on do
          node("Domain Last Updated Date") { |value| Time.parse(value) }
        end

        property_supported :expires_on do
          node("Domain Expiration Date") { |value| Time.parse(value) }
        end


        property_supported :registrar do
          node("Sponsoring Registrar") do |raw|
            Record::Registrar.new(
              :id           => node("Sponsoring Registrar IANA ID"),
              :name         => node("Sponsoring Registrar")
            )
          end
        end


        property_supported :registrant_contacts do
          build_contact("Registrant", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact("Administrative Contact", Whois::Record::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contacts do
          build_contact("Technical Contact", Whois::Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          Array.wrap(node("Name Server")).map do |name|
            Nameserver.new(name.downcase)
          end
        end


        # Initializes a new {Scanners::WhoisBiz} instance
        # passing the {#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::WhoisBiz.new(content_for_scanner).parse
        end


      private

        def build_contact(element, type)
          node("#{element} ID") do |raw|
            Record::Contact.new(
              :type         => type,
              :id           => node("#{element} ID"),
              :name         => node("#{element} Name"),
              :organization => node("#{element} Organization"),
              :address      => node("#{element} Address1"),
              :city         => node("#{element} City"),
              :zip          => node("#{element} Postal Code"),
              :state        => node("#{element} State/Province"),
              :country      => node("#{element} Country"),
              :country_code => node("#{element} Country Code"),
              :phone        => node("#{element} Phone Number"),
              :fax          => node("#{element} Facsimile Number"),
              :email        => node("#{element} Email")
            )
          end
        end

      end

    end
  end
end
