#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2011 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/parser/scanners/whoisit'


module Whois
  class Record
    class Parser

      #
      # = whois.nic.it parser
      #
      # Parser for the whois.nic.it server.
      #
      class WhoisNicIt < Base
        include Features::Ast


        property_supported :disclaimer do
          node("Disclaimer")
        end


        property_supported :domain do
          node("Domain") { |raw| raw.downcase }
        end

        property_not_supported :domain_id


        property_not_supported :referral_whois

        property_not_supported :referral_url


        property_supported :status do
          case node("Status").to_s.downcase
          when /^ok/, "active"
            :registered
          when /\bclient/
            :registered
          when "pendingdelete / redemptionperiod", "grace-period"
            :registered
          when "available"
            :available
          else
            Whois.bug!(ParserError, "Unknown status `#{node("Status")}'.")
          end
        end

        property_supported :available? do
          node("Status") == "AVAILABLE"
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("Created") { |raw| Time.parse(raw) }
        end

        property_supported :updated_on do
          node("Last Update") { |raw| Time.parse(raw) }
        end

        property_supported :expires_on do
          node("Expire Date") { |raw| Time.parse(raw) }
        end


        property_supported :registrar do
          node("Registrar") do |raw|
            Record::Registrar.new(
              :id           => raw["Name"],
              :name         => raw["Name"],
              :organization => raw["Organization"]
            )
          end
        end


        property_supported :registrant_contacts do
          contact("Registrant", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          contact("Admin Contact", Whois::Record::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contacts do
          contact("Technical Contacts", Whois::Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          Array.wrap(node("Nameservers")).map do |name|
            Record::Nameserver.new(name)
          end
        end


        # Checks whether this response contains a message
        # that can be reconducted to a "WHOIS Server Unavailable" status.
        #
        # @return [Boolean]
        def response_unavailable?
          !!node("status-unavailable")
        end

        # Initializes a new {Scanner} instance
        # passing the {Whois::Record::Parser::Base#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::Whoisit.new(content_for_scanner).parse
        end


        protected

          def contact(element, type)
            node(element) do |raw|
              address = (raw["Address"] || "").split("\n")
              company = address.size == 6 ? address.shift : nil
              Record::Contact.new(
                :id           => raw["ContactID"],
                :type         => type,
                :name         => raw["Name"],
                :organization => raw["Organization"] || company,
                :address      => address[0],
                :city         => address[1],
                :zip          => address[2],
                :state        => address[3],
                :country_code => address[4],
                :created_on   => raw["Created"] ? Time.parse(raw["Created"]) : nil,
                :updated_on   => raw["Last Update"] ? Time.parse(raw["Last Update"]) : nil
              )
            end
          end

      end

    end
  end
end
