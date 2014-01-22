#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/base_whoisd'


module Whois
  class Record
    class Parser

      # Base parser for Whoisd servers.
      #
      # @abstract
      class BaseWhoisd < Base
        include Scanners::Scannable

        class_attribute :status_mapping

        self.status_mapping = {
          "paid and in zone" => :registered,
          "expired" => :expired,
        }
        self.scanner = Scanners::BaseWhoisd


        property_supported :domain do
          node('domain')
        end

        property_not_supported :domain_id


        property_supported :status do
          node('status') do |value|
            values = Array.wrap(value)
            status = values.each do |s|
              v = self.class.status_mapping[s.downcase]
              break v if v
            end
            status || Whois.bug!(ParserError, "Unknown status `#{string}'.")
          end || :available
        end

        property_supported :available? do
          !!node('status:available')
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node('registered') { |string| Time.parse(string) }
        end

        property_supported :updated_on do
          node('changed') { |string| Time.parse(string) }
        end

        property_supported :expires_on do
          node('expire') { |string| Time.parse(string) }
        end


        property_supported :registrar do
          node('registrar') do |string|
            Whois::Record::Registrar.new(
                :id           => string,
                :name         => string
            )
          end
        end

        property_supported :registrant_contacts do
          node('registrant') do |value|
            build_contact(value, Record::Contact::TYPE_REGISTRANT)
          end
        end

        property_supported :admin_contacts do
          node('admin-c') do |value|
            build_contact(value, Record::Contact::TYPE_ADMINISTRATIVE)
          end
        end

        property_supported :technical_contacts do
          id = node_nsset['tech-c'] rescue nil
          if id
            build_contact(id, Record::Contact::TYPE_TECHNICAL)
          end
        end


        property_supported :nameservers do
          lines = node_nsset['nserver'] rescue nil
          Array.wrap(lines).map do |line|
            if line =~ /(.+) \((.+)\)/
              name = $1
              ipv4, ipv6 = $2.split(', ')
              Record::Nameserver.new(:name => name, :ipv4 => ipv4, :ipv6 => ipv6)
            else
              Record::Nameserver.new(:name => line.strip)
            end
          end
        end


      private

        def node_nsset
          node("node:nsset/#{node("nsset")}")
        end

        def build_contact(element, type)
          node("node:contact/#{element}") do |hash|
            address = hash['street'] || hash['address']
            address = address.join("\n") if address.respond_to?(:join)

            Record::Contact.new(
                :type           => type,
                :id             => element,
                :name           => hash['name'],
                :organization   => hash['org'],
                :address        => address,
                :city           => hash['city'],
                :zip            => hash['postal code'],
                :country_code   => hash['country'],
                :phone          => hash['phone'],
                :email          => hash['e-mail'],
                :created_on     => Time.parse(hash['created'])
            )
          end
        end

      end

    end
  end
end
