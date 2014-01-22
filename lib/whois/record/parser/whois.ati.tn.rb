#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/whois.ati.tn.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.ati.tn server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisAtiTn < Base
        include Scanners::Scannable

        self.scanner = Scanners::WhoisAtiTn


        property_supported :disclaimer do
          node("field:disclaimer")
        end


        property_supported :domain do
          node("Domain")
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
          !!node("status:available")
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("Acivated") { |value| Time.parse(value) }
        end

        property_not_supported :updated_on

        property_not_supported :expires_on


        property_supported :registrar do
          node("Registrar") do |value|
            Record::Registrar.new(
              :id           => nil,
              :name         => value
            )
          end
        end

        property_supported :registrant_contacts do
          build_contact("Owner", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact("Admin.", Whois::Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact("Tech.", Whois::Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          Array.wrap(node("NameServers")).map do |line|
            name, ipv4 = line.match(/(.+)\. \[(.+)\]/)[1, 2]
            Nameserver.new(:name => name, :ipv4 => ipv4)
          end
        end


      private

        def build_contact(element, type)
          node("#{element} Name") do
            Record::Contact.new(
              :type         => type,
              :id           => nil,
              :name         => node("#{element} Name"),
              :address      => node("#{element} Address"),
              :phone        => node("#{element} Tel"),
              :fax          => node("#{element} Fax"),
              :email        => node("#{element} Email"),
              :created_on   => node("#{element} Created") { |value| Time.parse(value) },
              :updated_on   => node("#{element} Updated") { |value| Time.parse(value) }
            )
          end
        end

      end

    end
  end
end
