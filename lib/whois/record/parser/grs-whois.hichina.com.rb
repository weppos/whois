#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/grs-whois.hichina.com'


module Whois
	class Record
    class Parser

      # Parser for the grs-whois.hichina.com server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class GrsWhoisHichinaCom < Base
        include Scanners::Scannable
        self.scanner = Scanners::GrsWhoisHichinaCom
        
        property_supported :disclaimer do
          node("field:disclaimer")
        end


        property_supported :domain do
          node("Domain Name", &:downcase)
        end

        property_not_supported :domain_id 


        property_not_supported :status 

        property_supported :available? do
          !!node("status:available")
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("Domain Create Date") do |value|
            Time.parse(value)
          end
        end

        property_not_supported :updated_on 

        property_supported :expires_on do
          node("Expiration Date") do |value|
            Time.parse(value)
          end
        end


        property_supported :registrar do
          node("Sponsoring Registrar") do |value|
            Record::Registrar.new(
                id:           nil,
                name:         value
            )
          end
        end

        property_supported :registrant_contacts do
          build_contact("Registrant", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact("Administrative", Whois::Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact("Technical", Whois::Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          if node?("Name Server")
            Array.wrap(node("Name Server").split).reject(&:empty?).map do |name|
              Nameserver.new(:name => name.downcase)
            end
          end
        end


        private

        def build_contact(element, type)
          node("#{element} ID") do
            Record::Contact.new(
                :type         => type,
                :id           => node("#{element} ID"),
                :name         => node("#{element} Name"),
                :organization => node("#{element} Organization"),
                :address      => node("#{element} Address"),
                :city         => node("#{element} City"),
                :zip          => node("#{element} Postal Code"),
                :state        => node("#{element} Province/State"),
                :country_code => node("#{element} Country Code"),
                :phone        => node("#{element} Phone Number"),
                :fax          => node("#{element} Fax"),
                :email        => node("#{element} Email")
            )
          end
        end

        def decompose_registrar(value)
          if value =~ /(.+?) \((.+?)\)/
            [$2, $1]
          end
        end


      end
  	end
  end
end
