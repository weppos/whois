#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/iana'


module Whois
  class Record
    class Parser

      # Parser for the whois.iana.org server.
      class WhoisIanaOrg < Base
        include Scanners::Scannable

        self.scanner = Scanners::Iana


        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /This query returned 0 objects|organisation: Not assigned/)
        end

        property_supported :registered? do
          !available?
        end


        # TODO: registrar

        property_supported :registrant_contacts do
          build_contact("organisation", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact("administrative", Whois::Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact("technical", Whois::Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :created_on do
          node("dates") { |raw| Time.parse(raw["created"]) if raw.has_key? "created" }
        end

        property_supported :updated_on do
          node("dates") { |raw| Time.parse(raw["changed"]) if raw.has_key? "changed" }
        end

        property_not_supported :expires_on


        property_supported :nameservers do
          node("nameservers") do |raw|
            (raw["nserver"] || "").split("\n").map do |line|
              name, ipv4 = line.downcase.split(/\s+/)
              Record::Nameserver.new(:name => name, :ipv4 => ipv4)
            end
          end
        end


      private

        def build_contact(element, type)
          node(element) do |raw|
            if raw["organisation"] != "Not assigned"
              address = (raw["address"] || "").split("\n")
              Record::Contact.new(
                :type         => type,
                :name         => raw["name"],
                :organization => raw["organisation"],
                :address      => address[0],
                :city         => address[1],
                :zip          => address[2],
                :country      => address[3],
                :phone        => raw["phone"],
                :fax          => raw["fax-no"],
                :email        => raw["e-mail"]
              )
            end
          end
        end

      end

    end
  end
end
