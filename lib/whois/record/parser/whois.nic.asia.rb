#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2015 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_afilias'


module Whois
  class Record
    class Parser

      # Parser for the whois.nic.asia server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisNicAsia < BaseAfilias

        self.scanner = Scanners::BaseAfilias, {
            pattern_reserved: /^Reserved by DotAsia\n/,
        }


        property_supported :status do
          if reserved?
            :reserved
          else
            Array.wrap(node("Domain Status"))
          end
        end


        property_supported :created_on do
          node("Domain Create Date") do |value|
            parse_time(value)
          end
        end

        property_supported :updated_on do
          node("Domain Last Updated Date") do |value|
            parse_time(value)
          end
        end

        property_supported :expires_on do
          node("Domain Expiration Date") do |value|
            parse_time(value)
          end
        end


        property_supported :admin_contacts do
          build_contact("Administrative", Whois::Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact("Technical", Whois::Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          Array.wrap(node("Nameservers")).reject(&:empty?).map do |name|
            Record::Nameserver.new(:name => name.downcase)
          end
        end


        # NEWPROPERTY
        def reserved?
          !!node("status:reserved")
        end


      private

        def build_contact(element, type)
          node("#{element} ID") do
            address = ["", "2", "3"].
                map { |i| node("#{element} Address#{i}") }.
                delete_if(&:empty?).
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
                :country_code => node("#{element} Country/Economy"),
                :phone        => node("#{element} Phone"),
                :fax          => node("#{element} FAX"),
                :email        => node("#{element} E-mail")
            )
          end
        end

      end

    end
  end
end
