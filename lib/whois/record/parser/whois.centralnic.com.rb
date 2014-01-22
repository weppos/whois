#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/whois.centralnic.com.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.centralnic.net server.
      class WhoisCentralnicCom < Base
        include Scanners::Scannable

        self.scanner = Scanners::WhoisCentralnicCom


        property_supported :disclaimer do
          node("field:disclaimer")
        end


        property_supported :domain do
          node("Domain Name") { |str| str.downcase }
        end

        property_supported :domain_id do
          node("Domain ID")
        end


        property_supported :status do
          # OK, RENEW PERIOD, ...
          Array.wrap(node("Status"))
        end

        property_supported :available? do
          !!node("status:available")
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("Created On") { |str| Time.parse(str) }
        end

        property_supported :updated_on do
          node("Last Updated On") { |str| Time.parse(str) }
        end

        property_supported :expires_on do
          node("Expiration Date") { |str| Time.parse(str) }
        end


        property_supported :registrar do
          node("Sponsoring Registrar ID") do
            Record::Registrar.new(
                :id           => node("Sponsoring Registrar ID"),
                :name         => nil,
                :organization => node("Sponsoring Registrar Organization"),
                :url          => node("Sponsoring Registrar Website")
            )
          end
        end

        property_supported :registrant_contacts do
          build_contact("Registrant", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact("Admin", Whois::Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact("Tech", Whois::Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          Array.wrap(node("Name Server")).map do |name|
            Record::Nameserver.new(:name => name.downcase.chomp("."))
          end
        end


      private

        def build_contact(element, type)
          node("#{element} ID") do
            address = (1..3).
                map { |i| node("#{element} Street#{i}") }.
                delete_if { |i| i.nil? || i.empty? }.
                join("\n")
            address = nil if address.empty?

            Record::Contact.new(
                :type         => type,
                :id           => node("#{element} ID"),
                :name         => node("#{element} Name"),
                :organization => node("#{element} Organization"),
                :address      => address,
                :city         => node("#{element} City"),
                :zip          => node("#{element} Postal Code"),
                :state        => node("#{element} State/Province"),
                :country_code => node("#{element} Country"),
                :phone        => node("#{element} Phone"),
                :fax          => node("#{element} FAX"),
                :email        => node("#{element} Email")
            )
          end
        end

      end

    end
  end
end
