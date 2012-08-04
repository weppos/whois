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
          match = content_for_scanner.slice(/#{element}.*\n((.*\n){5})/, 1)
          return unless match

          # 0 Almahdi, Ahmad  alatol@yahoo.com
          # 1 1-183 Carroll Street
          # 2 Dunedin,  9001
          # 3 NZ
          # 4 +1.6434701257

          lines = $1.split("\n")

          name, email = if lines[0].index('@')
            lines[0].scan(/(.+)  (.*)/).first.map(&:strip)
          else
            lines[0].strip
          end
          city, zip = lines[2].scan(/(.+?),  ([^\s]+)/).first.map(&:strip)
          phone = lines[4].strip if lines[4]

          Record::Contact.new(
            :type         => type,
            :name         => name,
            :organization => nil,
            :address      => lines[1].strip,
            :city         => city,
            :state        => nil,
            :zip          => zip,
            :country_code => lines[3].strip,
            :email        => email,
            :phone        => phone
          )
        end
      end
    end
  end
end
