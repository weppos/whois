#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/whois.nic.it.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.nic.it server.
      class WhoisNicIt < Base
        include Scanners::Scannable

        self.scanner = Scanners::WhoisNicIt


        property_supported :disclaimer do
          node("Disclaimer")
        end


        property_supported :domain do
          node("Domain") { |str| str.downcase }
        end

        property_not_supported :domain_id


        property_supported :status do
          case s = node("Status").to_s.downcase
          when /^ok/, "active", /\bclient/
            :registered
          when "grace-period", "no-provider"
            :registered
          when /^pendingupdate/
            :registered
          when /^pendingtransfer/
            :registered
          when /redemption\-/
            :redemption
          when "pending-delete"
            :redemption
          # The domain will be deleted in 5 days
          when /^pendingdelete/
            :redemption
          when "unassignable"
            :unavailable
          when "reserved"
            :reserved
          when "available"
            :available
          when /^inactive/
            :inactive
          else
            Whois.bug!(ParserError, "Unknown status `#{s}'.")
          end
        end

        property_supported :available? do
          status == :available
        end

        property_supported :registered? do
          !available? &&
          !unavailable?
        end

        # NEWPROPERTY
        def unavailable?
          status == :unavailable
        end


        property_supported :created_on do
          node("Created") { |str| Time.parse(str) }
        end

        property_supported :updated_on do
          node("Last Update") { |str| Time.parse(str) }
        end

        property_supported :expires_on do
          node("Expire Date") { |str| Time.parse(str) }
        end


        property_supported :registrar do
          node("Registrar") do |str|
            Record::Registrar.new(
                :id           => str["Name"],
                :name         => str["Name"],
                :organization => str["Organization"]
            )
          end
        end

        property_supported :registrant_contacts do
          build_contact("Registrant", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact("Admin Contact", Whois::Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact("Technical Contacts", Whois::Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          Array.wrap(node("Nameservers")).map do |name|
            Record::Nameserver.new(:name => name)
          end
        end


        # Checks whether this response contains a message
        # that can be reconducted to a "WHOIS Server Unavailable" status.
        #
        # @return [Boolean]
        def response_unavailable?
          !!node("response:unavailable")
        end


      private

        def build_contact(element, type)
          node(element) do |str|
            address = (str["Address"] || "").split("\n")
            company = address.size == 6 ? address.shift : nil
            Record::Contact.new(
              :id           => str["ContactID"],
              :type         => type,
              :name         => str["Name"],
              :organization => str["Organization"] || company,
              :address      => address[0],
              :city         => address[1],
              :zip          => address[2],
              :state        => address[3],
              :country_code => address[4],
              :created_on   => str["Created"] ? Time.parse(str["Created"]) : nil,
              :updated_on   => str["Last Update"] ? Time.parse(str["Last Update"]) : nil
            )
          end
        end

      end

    end
  end
end
