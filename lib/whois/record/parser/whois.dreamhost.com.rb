#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      # Parser for the whois.dreamhost.com server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisDreamhostCom < Base

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

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /Record expires on (.+)\.\n/
            Time.parse($1)
          end
        end


        property_supported :registrar do
          Record::Registrar.new(
            :name => "DreamHost",
            :organization => "New Dream Network, LLC.",
            :url  => "http://www.dreamhost.com/"
          )
        end

        property_supported :registrant_contacts do
          build_contact('Registrant Contact:', Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact('Administrative Contact:', Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact('Technical Contact:', Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          if content_for_scanner =~ /Domain servers in listed order:\n\n((?:\s*[^\s\n]+\n)+)/
            $1.split("\n").map do |line|
              Record::Nameserver.new(:name => line.strip)
            end
          end
        end


      private

        def build_contact(element, type)
          match = content_for_scanner.slice(/#{element}\n((.+\n)+)\n/, 1)
          return unless match

          lines = match.split("\n").map(&:strip)

          # 0 Name         Email
          # 1 Company
          # 2 Address
          # ? Address
          # 3 City, State Zip
          # 4 CountryCode
          # 5 Phone

          name, email = lines[0].split(/\s{5,}/)
          address = lines[2..-4].join("\n")
          city, state, zip = lines[-3].scan(/^(.+), ([A-Z]{2}) ([0-9]+)$/).first
          Record::Contact.new(
            :type         => type,
            :name         => name,
            :organization => lines[1],
            :address      => address,
            :city         => city,
            :state        => state,
            :zip          => zip,
            :country_code => lines[-2],
            :email        => email,
            :phone        => lines[-1],
            :fax          => nil
          )
        end

      end

    end
  end
end
