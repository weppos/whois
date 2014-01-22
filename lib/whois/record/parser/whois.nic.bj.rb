#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_afilias'


module Whois
  class Record
    class Parser

      # Parser for the whois.nic.bj server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisNicBj < Base


        property_not_supported :disclaimer


        property_supported :domain do
          if section =~ /Domain Name:\s+(.+)\n/
            $1
          end
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
          !!(content_for_scanner =~ /^No records matching/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if section =~ /Created:\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if section =~ /Updated:\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_not_supported :expires_on


        property_not_supported :registrar


        property_supported :registrant_contacts do
          if section =~ /Name:\s+(.+)\n/
            Record::Contact.new(
                type:         Whois::Record::Contact::TYPE_REGISTRANT,
                name:         $1
            )
          end
        end

        property_not_supported :admin_contacts

        property_not_supported :technical_contacts


        property_supported :nameservers do
          (1..4).map do |i|
            section =~ /Name Server #{i}:\s+(.+)\n/ ? Record::Nameserver.new(name: $1) : nil
          end.compact
        end


        private

        def build_contact(element, type)
          node("#{element} ID") do
            address = ["", "2", "3"].
                map { |i| node("#{element} Address#{i}") }.
                delete_if(&:empty?).
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
                :country_code => node("#{element} Country/Economy"),
                :phone        => node("#{element} Phone"),
                :fax          => node("#{element} FAX"),
                :email        => node("#{element} E-mail")
            )
          end
        end

        def section
          return @section if @section
          @section = content_for_scanner =~ /((?:Domain:.+\n)(?:.+:.+\n)+)\n/ ? $1 : ""
        end

      end

    end
  end
end
