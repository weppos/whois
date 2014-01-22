#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/whois.rnids.rs.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.rnids.rs server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisRnidsRs < Base
        include Scanners::Scannable

        self.scanner = Scanners::WhoisRnidsRs


        property_not_supported :disclaimer


        property_supported :domain do
          node("Domain name") { |str| str.chomp(".") }
        end

        property_not_supported :domain_id


        property_supported :status do
          case node("Domain status", &:downcase)
          when nil
            :available
          when 'active'
            :registered
          when 'locked'
            :registered
          when 'in transfer'
            :registered
          when 'expired'
            :expired
          else
            Whois.bug!(ParserError, "Unknown status `#{node("Domain status")}'.")
          end
        end

        property_supported :available? do
          !!node("status:available")
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("Registration date") { |value| Time.parse(value) }
        end

        property_supported :updated_on do
          node("Modification date") { |value| Time.parse(value) }
        end

        property_supported :expires_on do
          node("Expiration date") { |value| Time.parse(value) }
        end


        property_supported :registrar do
          node("Registrar") do |str|
            Record::Registrar.new(
              :id           => nil,
              :name         => node("Registrar")
            )
          end
        end


        property_supported :registrant_contacts do
          build_contact("Owner", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact("Administrative contact", Whois::Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact("Technical contact", Whois::Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          Array.wrap(node("DNS")).map do |line|
            name, ipv4 = line.split(/ - ?/).map(&:strip)
            name.chomp!(".")
            Nameserver.new(:name => name, :ipv4 => ipv4)
          end
        end


      private

        def build_contact(element, type)
          node(element) do |hash|
            Record::Contact.new(
              :type         => type,
              :id           => nil,
              :name         => hash[element],
              :organization => nil,
              :address      => hash["Address"],
              :city         => nil,
              :zip          => nil,
              :state        => nil,
              :country      => nil,
              :country_code => nil,
              :phone        => nil,
              :fax          => nil,
              :email        => nil
            )
          end
        end

      end

    end
  end
end
