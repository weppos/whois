#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/whois.gandi.net'


module Whois
  class Record
    class Parser

      # Parser for the whois.gandi.net server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      # @author Simone Carletti
      # @author Igor Dolzhikov <bluesriverz@gmail.com>
      # @since  3.2.1
      #
      class WhoisGandiNet < Base
        include Scanners::Scannable

        self.scanner = Scanners::WhoisGandiNet


        property_supported :disclaimer do
          node("field:disclaimer")
        end


        property_supported :domain do
          node("domain")
        end

        property_not_supported :domain_id


        property_supported :available? do
          !!node("status:available")
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("created") { |str| Time.parse(str) }
        end

        property_supported :updated_on do
          node("changed") { |str| Time.parse(str) }
        end

        property_supported :expires_on do
          node("expires") { |str| Time.parse(str) }
        end


        property_supported :registrar do
          Record::Registrar.new(
              :name         => 'GANDI Registrar',
              :organization => 'GANDI Registrar',
          )
        end


        property_supported :registrant_contacts do
          build_contact("owner-c", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact("admin-c", Whois::Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact("tech-c", Whois::Record::Contact::TYPE_TECHNICAL)
        end

        property_supported :nameservers do
          content_for_scanner.scan(/^ns\d{1}:\s(.*)/).flatten.map do |line|
            name, ipv4 = line.strip.split(" ")
            Record::Nameserver.new(:name => name.downcase, :ipv4 => ipv4)
          end
        end


        private

        def build_contact(element, type)
          match = content_for_scanner.slice(/#{element}:\n((\s\s.+\n)*)/, 1)
          return unless match

          # nic-hdl: NG270-GANDI
          # organisation: GANDI SAS
          # person: NOC GANDI
          # address: 63-65 Boulevard MASSENA
          # zipcode: 75013
          # city: Paris
          # country: France
          # phone: +33.143737851
          # fax: +33.143731851
          # email: 12e7da77f638acdf8d9f4d0b828ca80c-248842@contact.gandi.net
          # lastupdated: 2013-04-04 15:53:42
          Record::Contact.new(
              :type         => type,
              :id           => match.slice(/nic-hdl: (.*)/, 1),
              :name         => match.slice(/person: (.*)/, 1),
              :organization => match.slice(/organisation: (.*)/, 1),
              :address      => match.slice(/address: (.*)/, 1),
              :zip          => match.slice(/zipcode: (.*)/, 1),
              :city         => match.slice(/city: (.*)/, 1),
              :country      => match.slice(/country: (.*)/, 1),
              :phone        => match.slice(/phone: (.*)/, 1),
              :fax          => match.slice(/fax: (.*)/, 1),
              :email        => match.slice(/email: (.*)/, 1),
              :updated_on   => Time.parse(match.slice(/lastupdated: (.*)/, 1)),
          )
        end

      end
    end
  end
end
