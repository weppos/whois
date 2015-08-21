#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++

require 'whois/record/parser/base'
require 'whois/record/scanners/whois.eurodns.com.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.eurodns.com server.
      # This server is often redirected from whois.verisign.com server.
      # The tests are located in the folder:
      # spec/fixtures/responses/whois.eurodns.com/
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisEurodnsCom < Base
        include Scanners::Scannable

        self.scanner = Scanners::WhoisEurodnsCom

        property_supported :domain do
          node("Domain Name")
        end

        property_supported :domain_id do
          node("Registry Domain ID")
        end

        property_supported :status do
          # node("Status")
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /^No match for/)
        end

        property_supported :registered? do
          !available?
        end

        property_supported :created_on do
          node("Creation Date") { |value| Time.parse(value) }
        end

        property_supported :updated_on do
          node("Updated Date") { |value| Time.parse(value) }
        end

        property_supported :registrar do

          Whois::Record::Registrar.new(
              id:           node("Registrar IANA ID"),
              name:         node("Registrar"),
              url:          node("Registrar URL")
          )
        end

        property_supported :registrant_contacts do
          build_contact("Registrant", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact("Admin", Whois::Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact("Tech", Whois::Record::Contact::TYPE_TECHNICAL)
        end

        property_supported :nameservers do
          Array.wrap(node("Name Server")).reject { |value| value =~ /no nameserver/i }.map do |name|
            Nameserver.new(name: name.downcase)
          end
        end

        def build_contact(element, type)
          address = ["", "1", "2", "3"].
              map { |i| node("#{element} Street#{i}") }.
              delete_if { |i| i.nil? || i.empty? }.
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
              :country_code => node("#{element} Country"),
              :phone        => node("#{element} Phone"),
              :fax          => node("#{element} FAX") || node("#{element} Fax"),
              :email        => node("#{element} Email")
          ) 
        
        end
      end

    end
  end
end
