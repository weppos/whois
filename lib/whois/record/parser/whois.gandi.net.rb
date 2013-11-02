#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'yaml'
require 'whois/record/parser/base'


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
      #
      class WhoisGandiNet < Base
        include Scanners::Scannable


        property_not_supported :disclaimer


        property_supported :domain do
          node("domain")
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
          node("created") do |value|
            value.is_a?(Time) ? value : Time.parse(value)
          end
        end

        property_supported :updated_on do
          node("changed") do |value|
            value.is_a?(Time) ? value : Time.parse(value)
          end
        end

        property_supported :expires_on do
          node("expires") do |value|
            value.is_a?(Time) ? value : Time.parse(value)
          end
        end


        property_supported :registrar do
          Record::Registrar.new(
              name:         "GANDI Registrar",
              organization: "GANDI Registrar",
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
            Record::Nameserver.new(name: name.downcase, ipv4: ipv4)
          end
        end


        private

        def parse
          patched = content_for_scanner.dup
          patched.gsub!(/(zipcode|phone|fax): (.+)/, %Q{\\1: "\\2"})

          result = YAML.load(patched)
          unless result
            result = {}
            result["status:available"] = true
          end
          result
        end

        def build_contact(element, type)
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

          node(element) do |section|
            Record::Contact.new(
                type:         type,
                id:           section["nic-hdl"],
                name:         section["person"],
                organization: section["organisation"],
                address:      section["address"],
                zip:          section["zipcode"],
                city:         section["city"],
                country:      section["country"],
                phone:        section["phone"],
                fax:          section["fax"],
                email:        section["email"],
                updated_on:   (value = section["lastupdated"]).is_a?(Time) ? value : Time.parse(value),
            )
          end
        end

      end
    end
  end
end
