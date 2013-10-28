#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_icann_compliant'


module Whois
  class Record
    class Parser

      # Parser for the whois.planetdomain.com server.
      class WhoisPlanetdomainCom < BaseIcannCompliant
      	property_not_supported :registrar


        property_supported :status do
          status = Array.wrap(node('Status'))
          if status.empty?
            if available?
              :available
            else
              :registered
            end
          else 
            status
          end
        end

        property_supported :created_on do
          node('Creation Date') do |value|
            Time.parse(value)
          end
        end

        property_supported :updated_on do
          node('Updated Date') do |value|
            Time.parse(value)
          end
        end

        property_supported :expires_on do
          node('Expiration Date') do |value|
            Time.parse(value)
          end
        end

        property_supported :nameservers do
          if node?("Name Server 1")
            (1..2).map do |i| 
              if node?("Name Server #{i}")
                Nameserver.new(:name => node("Name Server #{i}").downcase)
              end
            end
          end
        end

        private
          def build_contact(element, type)
            node("#{element} Name") do
              address = (1..3).
                map { |i| node("#{element} Street #{i}") }.
                delete_if { |i| i.nil? || i.empty? }.
                join("\n")

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