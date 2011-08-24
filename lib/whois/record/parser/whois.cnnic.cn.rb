#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2011 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/parser/scanners/cnnic'


module Whois
  class Record
    class Parser

      #
      # = whois.cnnic.cn parser
      #
      # Parser for the whois.cnnic.cn server.
      #
      class WhoisCnnicCn < Base
        include Scanners::Ast


        property_not_supported :disclaimer


        property_supported :domain do
          node("Domain Name", &:downcase)
        end

        property_supported :domain_id do
          node("ROID")
        end


        property_not_supported :referral_whois

        property_not_supported :referral_url


        property_supported :status do
          Array.wrap node("Domain Status")
        end

        property_supported :available? do
          !!node("status-available")
        end

        property_supported :registered? do
          reserved? || !available?
        end


        property_supported :created_on do
          node("Registration Date") { |value| Time.parse(value) }
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          node("Expiration Date") { |value| Time.parse(value) }
        end


        property_supported :registrar do
          node("Sponsoring Registrar") do |value|
            Record::Registrar.new(
              :id =>    value,
              :name =>  value
            )
          end
        end

        property_supported :registrant_contacts do
          contact("Registrant", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          contact("Administrative", Whois::Record::Contact::TYPE_ADMIN)
        end

        property_not_supported :technical_contacts


        property_supported :nameservers do
          Array.wrap(node("Name Server")).map do |name|
            Nameserver.new(name.downcase)
          end
        end


        # NEWPROPERTY
        def reserved?
          !!node("status-reserved")
        end


        # Initializes a new {Scanners::Cnnic} instance
        # passing the {#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::Cnnic.new(content_for_scanner).parse
        end


        private

          def contact(element, type)
            n = node("#{element} Name")
            o = node("#{element} Organization")
            e = node("#{element} Email")
            return if n.nil? && o.nil? && e.nil?

            Record::Contact.new(
              :type         => type,
              :name         => n,
              :organization => o,
              :email        => e
            )
          end

      end
    end
  end
end
