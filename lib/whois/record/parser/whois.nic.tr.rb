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

      # Parser for the whois.nic.tr server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisNicTr < Base

        property_not_supported :disclaimer


        property_not_supported :domain

        property_not_supported :domain_id


        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /No match found for "(.+)"/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Created on\.+:\s+(.+)\n/
            time = Time.parse($1)
            Time.utc(time.year, time.month, time.day)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /Expires on\.+:\s+(.+)\n/
            time = Time.parse($1)
            Time.utc(time.year, time.month, time.day)
          end
        end


        property_not_supported :registrar


        property_supported :registrant_contacts do
          textblock = content_for_scanner.slice(/^\*\* Registrant:\n((?:\s+.+\n)+)/, 1)
          return unless textblock

          lines = textblock.lines.map(&:strip)

          name = lines[0]
          address = lines[1..2].delete_if(&:blank?).join("\n")
          city, country = if (lines[3] == "Out of Turkey,")
            [nil, lines[4]]
          else
            [lines[3].chomp(","), lines[4]]
          end

          Record::Contact.new(
            type:         Record::Contact::TYPE_REGISTRANT,
            name:         name,
            address:      address,
            city:         city,
            country:      country,
            email:        lines[5],
            phone:        lines[6],
            fax:          lines[7]
          )
        end

        property_supported :admin_contacts do
          build_contact("Administrative Contact", Whois::Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact("Technical Contact", Whois::Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          if content_for_scanner =~ /Domain Servers:\n((.+\n)+)\n/
            $1.split("\n").map do |line|
              name, ipv4 = line.split(/\s+/)
              Record::Nameserver.new(:name => name, :ipv4 => ipv4)
            end
          end
        end

      private

        def build_contact(element, type)
          textblock = content_for_scanner.slice(/^\*\* #{element}:\n((?:.+\n)+)\n/, 1)
          return unless textblock

          lines = []
          textblock.lines.each do |line|
            if line =~ /^\s+.+/
              lines.last.last << "\n" << line.strip
            else
              lines << line.match(/([^\t]+)\t+:\s+(.+)/).to_a[1..2]
            end
          end
          lines = Hash[lines]

          Record::Contact.new(
              type:         type,
              id:           lines["NIC Handle"],
              name:         lines["Person"],
              organization: lines["Organization Name"],
              address:      lines["Address"],
              phone:        lines["Phone"],
              fax:          lines["Fax"]
            )
        end

      end

    end
  end
end
