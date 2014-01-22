#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/whois.sx.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.sx server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisSx < Base
        include Scanners::Scannable

        self.scanner = Scanners::WhoisSx


        property_supported :disclaimer do
          node("field:disclaimer")
        end


        property_supported :domain do
          node("Domain Name", &:downcase)
        end

        property_supported :domain_id do
          node("Domain ID")
        end


        property_supported :status do
          case (s = node("Domain Status", &:downcase))
          when "available"
            :available
          when "ok"
            :registered
          when "premium name"
            :unavailable
          else
            Whois.bug!(ParserError, "Unknown status `#{s}'.")
          end
        end

        property_supported :available? do
          status == :available
        end

        property_supported :registered? do
          status == :registered
        end


        property_supported :created_on do
          node("Creation Date") { |value| parse_time(value) }
        end

        property_supported :updated_on do
          node("Updated Date") { |value| parse_time(value) }
        end

        property_supported :expires_on do
          node("Registry Expiry Date") { |value| parse_time(value) }
        end


        property_supported :registrar do
          node("Sponsoring Registrar") do |value|
            Record::Registrar.new(
                :name         => value
            )
          end
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
          Array.wrap(node("Name Server")).map do |name|
            Record::Nameserver.new(:name => name)
          end
        end


      private

        def parse_time(value)
          # Hack to remove usec. Do you know a better way?
          Time.utc(*Time.parse(value).to_a)
        end

        def build_contact(element, type)
          node("#{element} ID") do |id|
            Record::Contact.new(
                :type         => type,
                :id           => id,
                :name         => node("#{element} Name"),
                :organization => node("#{element} Organization"),
                :address      => node("#{element} Street"),
                :city        => node("#{element} City"),
                :zip          => node("#{element} Postal Code"),
                :country      => node("#{element} Country"),
                :email        => node("#{element} Email")
            )
          end
        end

      end

    end
  end
end
