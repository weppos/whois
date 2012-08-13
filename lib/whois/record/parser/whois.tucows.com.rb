#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      # Parser for the whois.tucows.com server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      class WhoisTucowsCom < Base

        property_not_supported :status

        # The server is contacted only in case of a registered domain.
        property_supported :available? do
          false
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Record created on (.+)\.\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Record last updated on (.+)\.\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Record expires on (.+)\.\n/
            Time.parse($1)
          end
        end


        property_supported :registrar do
          Record::Registrar.new(
              :name         => 'Tucows',
              :organization => 'Tucows',
              :url          => 'http://www.tucows.com/'
          )
        end

        property_supported :registrant_contacts do
          build_contact('Registrant:', Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact('Administrative Contact', Record::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contacts do
          build_contact('Technical Contact', Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
         if content_for_scanner =~ /Domain servers in listed order:\n((.+\n)+)\n/
            $1.split("\n").map do |line|
              Record::Nameserver.new(:name => line.strip.downcase)
            end
          end
        end


      private

        def build_contact(element, type)
          indent = type == Record::Contact::TYPE_REGISTRANT ? 1 : 4
          match  = content_for_scanner.slice(/#{element}.*\n((#{' ' * indent}.+\n)+)/, 1)
          return unless match

          # 0 Almahdi, Ahmad  alatol@yahoo.com
          # 1 1-183 Carroll Street
          # 2 Dunedin,  9001
          # 3 NZ
          # 4 +1.6434701257

          lines = $1.split("\n")
          items = lines.dup

          name, email = if items[0].index('@')
            items.delete_at(0).scan(/(.+)  (.*)/).first.map(&:strip)
          else
            items.delete_at(0).strip
          end

          phone, fax = if items[-1] =~ /^\s+\+?\d+/
            items.delete_at(-1).match(/\s+(.+?)\s*(?:Fax: (.+))?$/).to_a[1,2]
          end

          country = items.delete_at(-1).strip

          city, state, zip = items.delete_at(-1).scan(/(.+?), ([^\s]*?) (.+)/).first.map(&:strip)

          address = items.map(&:strip).join("\n")

          Record::Contact.new(
            :type         => type,
            :name         => name,
            :organization => nil,
            :address      => address,
            :city         => city,
            :state        => state,
            :zip          => zip,
            :country_code => country,
            :email        => email,
            :phone        => phone,
            :fax          => fax
          )
        end
      end
    end
  end
end
