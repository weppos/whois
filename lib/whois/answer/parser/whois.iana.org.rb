#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
#
# Category::    Net
# Package::     Whois
# Author::      Simone Carletti <weppos@weppos.net>
# License::     MIT License
#
#--
#
#++


require 'whois/answer/parser/base'
require 'whois/answer/parser/scanners/iana'


module Whois
  class Answer
    class Parser

      #
      # = whois.iana.org parser
      #
      # Parser for the whois.iana.org server.
      #
      class WhoisIanaOrg < Base
        include Ast

        property_supported :status do
          @status ||= if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          @available  ||= !!(content_for_scanner =~ /This query returned 0 objects|organisation: Not assigned/)
        end

        property_supported :registered? do
          @registered ||= !available?
        end


        property_supported :registrant_contact do
          @registrant_contact ||= contact("organisation", Whois::Answer::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contact do
          @admin_contact ||= contact("administrative", Whois::Answer::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contact do
          @technical_contact ||= contact("technical", Whois::Answer::Contact::TYPE_TECHNICAL)
        end


        property_supported :created_on do
          @created_on ||= node("dates") { |raw| Time.parse(raw["created"]) if raw.has_key? "created" }
        end

        property_supported :updated_on do
          @updated_on ||= node("dates") { |raw| Time.parse(raw["changed"]) if raw.has_key? "changed" }
        end

        property_not_supported :expires_on


        property_supported :nameservers do
          @nameservers ||= nameserver("nameservers") || []
        end


        protected

          def parse
            Scanners::Iana.new(content_for_scanner).parse
          end

          def contact(element, type)
            node(element) do |raw|
              if raw["organisation"] != "Not assigned"
                address = (raw["address"] || "").split("\n")
                Answer::Contact.new(
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

          def nameserver(element)
            node(element) do |raw|
              (raw["nserver"] || "").split("\n").map do |nameserver|
                Answer::Nameserver.new(*nameserver.downcase.split(" "))
              end
            end
          end

      end

    end
  end
end
