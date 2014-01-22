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

      # Parser for the whois.educause.edu server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisEducauseEdu < Base

        property_supported :disclaimer do
          if content_for_scanner =~ /\A((.*\n)+)\n--------------------------\n/
            $1
          else
            Whois.bug!(ParserError, "Unable to parse disclaimer.")
          end
        end


        property_supported :domain do
          if content_for_scanner =~ /Domain Name:\s(.+?)\n/
            $1.downcase
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
          !!(content_for_scanner =~ /No Match/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Domain record activated:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Domain record last updated:\s+(.+?)\n/
            Time.parse($1) unless $1 == 'unknown'
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Domain expires:\s+(.+?)\n/
            Time.parse($1)
          end
        end


        property_not_supported :registrar

        property_supported :registrant_contacts do
          build_contact_registrant("Registrant", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact("Administrative Contact", Whois::Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact("Technical Contact", Whois::Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          if content_for_scanner =~ /Name Servers: \n((.+\n)+)\n/
            $1.split("\n").map do |line|
              name, ipv4 = line.strip.split(/\s+/)
              Record::Nameserver.new(:name => name.downcase, :ipv4 => ipv4)
            end
          end
        end


      private

        # [NAME] | EMPTY
        # [ROLE]?
        # [ORGANIZATION]
        # [ADDRESS]*
        # [CITY, ST ZIP]
        # [COUNTRY]
        # [PHONE]
        # [EMAIL]
        def build_contact(element, type)
          if content_for_scanner =~ /#{element}:\n+((.+\n)+)\n/
            lines = $1.split("\n").map(&:strip)
            items = lines.dup

            # Extract variables

            # items.shift if items[0].strip == ''

            v13 = items.delete_at(-1)

            v11 = items.delete_at(-1)

            v9 = items.delete_at(-1)

            v6 = items.delete_at(-1)
            if v6 =~ /([^\n,]+),\s([A-Z]{2})(?:\s(\d{5}(?:-\d{4})?))/
              v6, v7, v8 = $1, $2, $3
            end

            v4 = []
            until items[0] =~ /^\d+/ || items.empty?
              v4 << items.shift
            end
            v4 = v4.join("\n")

            v5 = items.empty? ? nil : items.join("\n")

            # Create Contact

            Record::Contact.new(
                :type         => type,
                :name         => v4,
                :organization => nil,
                :address      => v5,
                :city         => v6,
                :state        => v7,
                :zip          => v8,
                :country      => v9,
                :phone        => v11,
                :email        => v13
            )
          end
        end

        # [ORGANIZATION]
        # [ADDRESS]*
        # [CITY, ST ZIP] | [CITY]
        # [COUNTRY]
        def build_contact_registrant(element, type)
          if content_for_scanner =~ /#{element}:\n((.+\n)+)\n/
            lines = $1.split("\n").map(&:strip)
            items = lines.dup

            # Extract variables

            v9 = items.delete_at(-1)

            v4 = items.delete_at(0)

            v6 = items.delete_at(-1)
            if v6 =~ /([^\n,]+),\s([A-Z]{2})(?:\s(\d{5}))/
              v6, v7, v8 = $1, $2, $3
            end

            v5 = items.empty? ? nil : items.join("\n")

            # Create Contact

            Record::Contact.new(
                :type         => type,
                :name         => nil,
                :organization => v4,
                :address      => v5,
                :city         => v6,
                :state        => v7,
                :zip          => v8,
                :country      => v9
            )
          end
        end

      end

    end
  end
end
